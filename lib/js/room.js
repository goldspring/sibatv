chatroomRef = null;
msgsView = [];
nMembers = [];


const _p = (chatroom, method, opts) => new Promise((resolve, reject) => chatroom[method]({
	...opts, done: (err, obj) => err ? reject(err) : resolve(obj),
}));

const appKey = process.env.NIM_API_KEY;
const chatroomAddresses = [process.env.NIM_WEB_LINKADDR];

const reset = () => {
	chatroomRef = null;
	roomId = "";
	msgsView = [];
	nMembers = [];
};

const debug = () => {
	console.log(SDK);
	console.log(chatroomRef);
	console.log(roomId);
	console.log(msgsView);
	console.log(nMembers);
};

const init = (roomId) => {
	const chatroomNew = SDK.Chatroom.getInstance({
		appKey,
		isAnonymous: true,
		chatroomNick: 'RO',
		chatroomId: roomId,
		chatroomAddresses,
		onconnect,
		onwillreconnect,
		ondisconnect,
		onerror,
		onmsgs,
	});
	chatroomRef = chatroomNew;
};
const onconnect = chatroomInfo => {
	console.log('onconnect');
	console.log(chatroomInfo);
	console.log(chatroomRef);
	(async () => {
		let cnt = 0;
		let timetag = msgsView[0]?.time;  // = undefined
		while (true) {
			console.log('auto');
			console.log(timetag);
			const obj = await _p(chatroomRef, 'getHistoryMsgs', {timetag});
			if (++cnt >= 30) break;
			if (obj.msgs.length === 0) break;
			const msgs = [...obj.msgs];
			msgs.reverse();
			var msgsPrev = msgsView;
			msgsView = (() => {
				const msgsSanitized = sanitizeDelta(msgs, msgsPrev, 'dupAudo');
				return [...msgsSanitized, ...msgsPrev];
			})();
			setMessagesView(msgsView);
			timetag = msgs[0].time;
			const dt = new Date(timetag);
			if (new Date() - dt >= 86400e3) break;
		}
		console.log(msgsView);
	})();
};
const onwillreconnect = (...args) => { console.log('reconnect'); console.log(args); };
const ondisconnect = err => {
	console.log('ondisconnect');
	console.log(err);
};
const onerror = (...args) => { console.log('e');console.log(args); };

g_timetag = 0;
const onmsgs = msgs => {
	var msgsPrev = msgsView;
	msgsView = (() => {
		const msgsSanitized = sanitizeDelta(msgs, msgsPrev, 'dupNew');
		return [...msgsPrev, ...msgsSanitized];
	})();

	const dt = new Date(g_timetag);
	const ndt = new Date();
	console.log('teime');
	console.log(ndt- dt);
    if (ndt- dt >= 1e3) {
      g_timetag = ndt.getTime();
	  setMessagesView(msgsView);
	}
};
const sanitizeDelta = (msgs, msgsPrev, tag) => {
	const msgsNoResend = msgs.filter(msg => !msg.resend);
	const msgsParsed = msgsNoResend.map(msg => ({
		...msg,
		custom: JSON.parse(msg.custom || null),
	}));
	// Mostly unnecessary after `resend` check.
	// But consecutive button clicks can send dup requests.
	const byKey = new Map(msgsPrev.map((msg, idx) => [msg.idClient, idx]));
	const lookup = msgsParsed.map((msg, idx) => [idx, msg, byKey.get(msg.idClient)]);
	const dups = lookup.filter(
		([idx, msg, idxEx]) => idxEx !== undefined
	).map(
		([idx, msg, idxEx]) => [idx, msg, idxEx, msgsPrev[idxEx]]
	);
	if (dups.length > 0) console.log(tag, dups);
	const msgsNoDup = lookup.filter(
		([idx, msg, idxEx]) => idxEx === undefined
	).map(
		([idx, msg, idxEx]) => msg
	);
	return msgsNoDup;
};
const earlier = () => {
	chatroomRef.getHistoryMsgs({
		timetag: msgsView[0]?.time,
		done: (err, obj) => {
			if (err) {
				console.log(err);
				return;
			}
			const msgs = [...obj.msgs];
			msgs.reverse();
			msgsView = ((msgsPrev) => {
				const msgsSanitized = sanitizeDelta(msgs, msgsPrev, 'dupHist');
				return [...msgsSanitized, ...msgsPrev];
			})();
			setMessagesView(msgsView);
		},
	});
};


const deleted = new Set(msgsView.filter(
	msg => msg.custom?.messageType === 'DELETE'
).map(msg => msg.custom.targetId));


const refresh = () => {
	let n = 0;
	let time = undefined;
	try {
		while (true) {
			const { members } = chatroomRef.getChatroomMembers({guest: true, time});
			n += members.length;
			if (members.length < 100) break;
			time = members[members.length-1].enterTime;
		}
	} catch (err) {
		console.log('refresh');
		console.log(err);
	}
	return n;
};
