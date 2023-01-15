package com.frogmind.hypehype.hh_screen_recorder;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Icon;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;
import android.media.MediaCodecInfo;
import android.media.MediaRecorder;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.IBinder;
import android.os.ResultReceiver;
import android.provider.MediaStore;
import android.util.Log;
import android.text.TextUtils;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileDescriptor;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import java.io.BufferedReader;
import java.io.FileReader;
import android.media.MediaCodecList;
import android.database.Cursor;
public class ScreenCaptureService extends Service {

    private static final boolean DEBUG = true;
    private static final String APP_DIR_NAME = "ScreenRecorder";

    String CHANNEL_ID = "1432";

    private static final String BASE = "com.mordred.mordredrecorder.RecorderService.";
    public static final String ACTION_START = BASE + "ACTION_START";
    public static final String ACTION_STOP = BASE + "ACTION_STOP";
    public static final String ACTION_QUERY_STATUS = BASE + "ACTION_QUERY_STATUS";
    public static final String ACTION_QUERY_STATUS_RESULT = BASE + "ACTION_QUERY_STATUS_RESULT";
    public static final String EXTRA_RESULT_CODE = BASE + "EXTRA_RESULT_CODE";
    public static final String EXTRA_QUERY_RESULT_RECORDING = BASE + "EXTRA_QUERY_RESULT_RECORDING";
    public static final String EXTRA_QUERY_RESULT_PAUSING = BASE + "EXTRA_QUERY_RESULT_PAUSING";
    private static final int NOTIFICATION = 2023;

    private MediaProjectionManager mMediaProjectionManager;
    private NotificationManager mNotificationManager;

    private static RecorderThread sMuxer;

    public final static String ERROR_KEY = "error";

    private MediaRecorder m_mediaRecorder;
    private MediaProjection m_mediaProjection;
    private VirtualDisplay m_virtualDisplay;
    private int m_screenWidth = 0;
    private int m_screenHeight = 0;
    private int m_screenDensity = 0;
    private int m_mediaProjCode = 0;
    private boolean m_recordAudio = false;
    private Intent m_mediaProjData;
    private String m_fullPath = "";
    private static final String TAG = "ScreenRecordService";
    private boolean m_isRecording = false;
    private Uri m_uri = null;

    @Override
    public void onCreate() {
        System.out.println("RecorderService: onCreate");
        super.onCreate();
        if (DEBUG) Log.v(TAG, "onCreate:");
        mMediaProjectionManager = (MediaProjectionManager)getSystemService(Context.MEDIA_PROJECTION_SERVICE);
        mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
    }
    public boolean isNvidia() {

        boolean ret = false;
        int numCodecs=MediaCodecList.getCodecCount();
        for (int i = 0; i < numCodecs; i++) {
            MediaCodecInfo codecInfo = MediaCodecList.getCodecInfoAt(i);
            if (!codecInfo.isEncoder()) {
                continue;
            }
            String[] types = codecInfo.getSupportedTypes();
            for (int j = 0; j < types.length; j++) {
                //if (types[j].equalsIgnoreCase("video/avc")) {
                Log.d("TYPE_NAME",types[j]);
                String codec = codecInfo.getName();
                Log.d("CODEC_NAME", codec);
                if (codec.toLowerCase().contains("nvidia")){
                    ret = true;
                }
                //}
            }
        }
        return ret;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        String saction = intent.getAction();
        System.out.println("HHRecorder: start command received successfully." + saction);

        if(intent != null && (intent.getAction().equals("pause") || intent.getAction().equals("resume")))
        {
            System.out.println("intent");
            if(intent.getAction().equals("pause"))
            {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    m_mediaRecorder.pause();
                    HhScreenRecorderPlugin._instance.onPausedRecording();
                }
            }
            else if(intent.getAction().equals("resume"))
            {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    m_mediaRecorder.resume();
                    HhScreenRecorderPlugin._instance.onResumedRecording();
                }
            }
        }
        else
        {
            System.out.println("notification");
            // CREATE NOTIFICATION && START FOREGROUND SERVICE
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                String channelId = "001";
                String channelName = "RecordChannel";
                NotificationChannel channel = new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_NONE);
                channel.setLightColor(Color.BLUE);
                channel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
                NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                if (manager != null) {
                    manager.createNotificationChannel(channel);
                    Notification notification;

                    Intent myIntent = new Intent(this, NotificationReceiver.class);
                    PendingIntent pendingIntent;

                    if (Build.VERSION.SDK_INT >= 31){
                        pendingIntent = PendingIntent.getBroadcast(this, 0, myIntent, PendingIntent.FLAG_IMMUTABLE);
                    }else{
                        pendingIntent = PendingIntent.getBroadcast(this, 0, myIntent, 0);

                    }

                    String notificationButtonText = "Button";
                    String notificationTitle = "Recording your screen.";
                    String notificationMessage = "Drag down to stop the recording.";

                    Notification.Action action = new Notification.Action.Builder(
                            Icon.createWithResource(this, android.R.drawable.presence_video_online),
                            notificationButtonText,
                            pendingIntent).build();

                    notification = new Notification.Builder(getApplicationContext(), channelId).setOngoing(true).setSmallIcon(R.drawable.icon).setContentTitle(notificationTitle).setContentText(notificationMessage).addAction(action).build();
                    System.out.println("start with notification");
                    startForeground(101, notification);
                }
            }
            else {
                System.out.println("start new notification");
                startForeground(101, new Notification());
            }

            m_mediaProjCode = intent.getIntExtra("mediaProjCode", -1);
            m_mediaProjData = intent.getParcelableExtra("mediaProjData");

            System.out.println("RecorderService: startScreenRecord");
            if (sMuxer == null) {
                System.out.println("RecorderService: createMuxer");
                //final int resultCode = intent.getIntExtra(EXTRA_RESULT_CODE, 0);
                // get MediaProjection
                //final MediaProjection projection = mMediaProjectionManager.getMediaProjection(resultCode, intent);
                initMediaProjection();
                MediaProjection  projection =  m_mediaProjection;
                System.out.println("RecorderService: projection");
                if (projection != null) {
                    System.out.println("RecorderService: createProjection");
                    final DisplayMetrics metrics = getResources().getDisplayMetrics();
                    int width = metrics.widthPixels;
                    int height = metrics.heightPixels;
                    if (width > height) {
                        // Horizontal
                        final float scale_x = width / 1920f;
                        final float scale_y = height / 1080f;
                        final float scale = Math.max(scale_x,  scale_y);
                        width = (int)(width / scale);
                        height = (int)(height / scale);
                    } else {
                        // Vertical
                        final float scale_x = width / 1080f;
                        final float scale_y = height / 1920f;
                        final float scale = Math.max(scale_x,  scale_y);
                        width = (int)(width / scale);
                        height = (int)(height / scale);
                    }

                    if (isNvidia()){
                        Log.v(TAG, String.format("startRecording:(%d,%d)(%d,%d)", metrics.widthPixels, metrics.heightPixels, width, height));
                        System.out.println("RecorderService: IsNvidia");
                        //todo only Tegra
                        width = (int)((Math.ceil(width / 16f)) * 16f);
                        height = (int)((Math.ceil(height / 16f)) * 16f);
                    }

                    if (DEBUG) Log.v(TAG, String.format("startRecording:(%d,%d)(%d,%d)", metrics.widthPixels, metrics.heightPixels, width, height));
                    //m_fullPath = intent.getStringExtra("fullpath");

                    m_uri = intent.hasExtra("uri") ? Uri.parse(intent.getStringExtra("uri")): null;
                    if (m_uri != null) {
                        try {
                            ContentResolver contentResolver = getContentResolver();
                            FileDescriptor inputPFD = Objects.requireNonNull(contentResolver.openFileDescriptor(m_uri, "rw")).getFileDescriptor();
                            System.out.println("RecorderService: record path:" + m_fullPath);
                            sMuxer = new RecorderThread(projection, inputPFD, width, height,
                                    calcBitRate(30, width, height));
                        } catch (Exception e) {

                        }
                    }
                    if (sMuxer == null) {
                        System.out.println("RecorderService: record path:" + m_fullPath);
                        sMuxer = new RecorderThread(projection, m_fullPath, width, height,
                                calcBitRate(30, width, height));
                    }
                    sMuxer.startRecording();
                    HhScreenRecorderPlugin._instance.onStartedCapture();
                }
            }

            /*
            // Retrieve params
            m_screenWidth = intent.getIntExtra("width", 0);
            m_screenHeight = intent.getIntExtra("height", 0);

            if(m_screenWidth == 0 || m_screenHeight == 0)
            {
                HhScreenRecorderPlugin._instance.onFailedToStartCapture( "Screen width or height is zero!");
                return Service.START_STICKY;
            }
            m_screenDensity = intent.getIntExtra("density", 1);
            m_mediaProjCode = intent.getIntExtra("mediaProjCode", -1);
            m_mediaProjData = intent.getParcelableExtra("mediaProjData");
            m_recordAudio = intent.getBooleanExtra("recordAudio", false);
            m_uri = intent.hasExtra("uri") ? Uri.parse(intent.getStringExtra("uri")): null;

            if(m_uri == null)
                m_fullPath = intent.getStringExtra("fullpath");

            // INIT
            try{
                initRecorder();
            } catch (Exception e)
            {
                HhScreenRecorderPlugin._instance.onFailedToStartCapture( "Failed to init media recorder: " + Log.getStackTraceString(e));
                return Service.START_STICKY;
            }

            try{
                initMediaProjection();
            }
            catch (Exception e)
            {
                HhScreenRecorderPlugin._instance.onFailedToStartCapture( "Failed to init media projection: " + Log.getStackTraceString(e));
                return Service.START_STICKY;
            }

            try{
                initVirtualDisplay();
            }
            catch (Exception e)
            {
                HhScreenRecorderPlugin._instance.onFailedToStartCapture( "Failed to init virtual display: " + Log.getStackTraceString(e));
                return Service.START_STICKY;
            }

            m_mediaRecorder.setOnErrorListener(new MediaRecorder.OnErrorListener() {
                @Override
                public void onError(MediaRecorder mediaRecorder, int i, int i1) {
                    HhScreenRecorderPlugin._instance.onMediaRecorderError(i, i1);
                }
            });

            m_mediaRecorder.setOnInfoListener(new MediaRecorder.OnInfoListener() {
                @Override
                public void onInfo(MediaRecorder mediaRecorder, int i, int i1) {
                    HhScreenRecorderPlugin._instance.onMediaRecorderInfo(i, i1);
                }
            });

            try
            {
                m_mediaRecorder.start();
                m_isRecording = true;
                HhScreenRecorderPlugin._instance.onStartedCapture();
            }
            catch (Exception e)
            {
                HhScreenRecorderPlugin._instance.onFailedToStartCapture("Failed to start media recorder: " + Log.getStackTraceString(e));
                return Service.START_STICKY;
            }
            */
        }

        return Service.START_STICKY;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        if (sMuxer != null) {
            sMuxer.stopRecording();
            sMuxer = null;
        }
        if (mNotificationManager != null) {
            mNotificationManager.cancel(NOTIFICATION);
            mNotificationManager = null;
        }
        if(m_isRecording)
        {
            m_isRecording = false;
            m_mediaRecorder.stop();
        }

        HhScreenRecorderPlugin._instance.onServiceDestroyed();
        stopForeground(true);
        stopSelf();

        if(m_virtualDisplay != null)
        {
            m_virtualDisplay.release();
            m_virtualDisplay = null;
        }

        if(m_mediaRecorder != null)
        {
            m_mediaRecorder.setOnErrorListener(null);
            m_mediaRecorder.reset();
        }

        if(m_mediaProjection != null)
        {
            m_mediaProjection.stop();
            m_mediaProjection = null;
        }

        super.onDestroy();
    }
/*
    private void initRecorder() throws IOException {
        m_mediaRecorder = new MediaRecorder();

        if(m_recordAudio)
        {
            m_mediaRecorder.setAudioSource(MediaRecorder.AudioSource.REMOTE_SUBMIX);
            m_mediaRecorder.setAudioEncodingBitRate(128000);
            m_mediaRecorder.setAudioSamplingRate(44100);
        }

        m_mediaRecorder.setVideoSource(MediaRecorder.VideoSource.SURFACE);
        System.out.println("HHRecorder: Selecting encoder, target mime type: " + HhScreenRecorderPlugin.SELECTED_MIME_TYPE);

        if(HhScreenRecorderPlugin.SELECTED_MIME_TYPE.equals(HhScreenRecorderPlugin.MIME_TYPE_FALLBACK))
            m_mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
        else
            m_mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);

        if(m_recordAudio)
        {
            m_mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
        }
        m_mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
        m_mediaRecorder.setVideoSize(m_screenWidth, m_screenHeight);
        //m_mediaRecorder.setVideoEncodingBitRate(12000000);
        m_mediaRecorder.setVideoEncodingBitRate(5 * m_screenWidth * m_screenHeight);
        m_mediaRecorder.setVideoFrameRate(60);

        if (m_uri != null) {
            try {
                ContentResolver contentResolver = getContentResolver();
                FileDescriptor inputPFD = Objects.requireNonNull(contentResolver.openFileDescriptor(m_uri, "rw")).getFileDescriptor();
                m_mediaRecorder.setOutputFile(inputPFD);
                System.out.println("HHRecorder: Setting output path (from uri): " + m_uri.toString());
            } catch (Exception e) {
                System.out.println("HHRecorder: Media Recorder Set output file failed");
                throw new IOException();
            }
        }else{
            m_mediaRecorder.setOutputFile(m_fullPath);
            System.out.println("HHRecorder: Setting output path: " + m_fullPath);
        }

        m_mediaRecorder.prepare();
    }
*/
    private void initMediaProjection()
    {
        m_mediaProjection = ((MediaProjectionManager) Objects.requireNonNull(getSystemService(Context.MEDIA_PROJECTION_SERVICE))).getMediaProjection(m_mediaProjCode, m_mediaProjData);
    }

    protected int calcBitRate(final int frameRate, int width, int height) {
        final int bitrate = (int)(0.25f * frameRate * width * height);
        Log.i(TAG, String.format("bitrate=%5.2f[Mbps]", bitrate / 1024f / 1024f));
        return bitrate;
    }
    /*
    private void stopScreenRecord() {
        System.out.println("stop Record");
        if (sMuxer != null) {
            System.out.println("stop Record smUxer");
            sMuxer.stopRecording();
        }
        stopForeground(true  //removeNotification*);

        if (mNotificationManager != null) {
            mNotificationManager.cancel(NOTIFICATION);
            mNotificationManager = null;
        }
        stopSelf();
    }
    */

}