package com.google.cannonshop;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Process;
import android.provider.Settings;

import org.json.JSONArray;
import org.json.JSONException;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.SharedPreferences;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "backgroundservice").setMethodCallHandler(
                ((call, result) -> {
                    if(call.method.equals("getExternalStorageDirectory")){
                        result.success(Environment.getExternalStorageDirectory().toString());
                    }

                    if(call.method.equals("security")){
                        try {
                            Signature sig = getApplicationContext().getPackageManager().getPackageInfo(getApplicationContext().getPackageName(), PackageManager.GET_SIGNATURES).signatures[0];
                            result.success(""+sig.hashCode());
                        } catch (PackageManager.NameNotFoundException e) {
                            e.printStackTrace();
                        }
                    }
                    if(call.method.equals("appID")){
                        checkAppCloning();
                        result.success(getApplicationContext().getPackageName().toString());

                    }




                    // result.success(1);

                })
        );

    }

    private static final int APP_PACKAGE_DOT_COUNT=3;
    private static final String DUAL_APP_ID_999="999";
    private static final char DOT='.';

    private void checkAppCloning(){
        String path = getFilesDir().getPath();
        if(path.contains(DUAL_APP_ID_999)){
            killProcess();
        }else{
            int count = getDotCount(path);
            if (count>APP_PACKAGE_DOT_COUNT){
                killProcess();
            }
        }
    }



    private int getDotCount(String path){
        int count = 0;
        for(int i =0;i<path.length();i++){
            if(count> APP_PACKAGE_DOT_COUNT){
                break;
            }
            if(path.charAt(i)==DOT){
                count++;
            }
        }
        return count;
    }

    private void killProcess(){
        finish();
        Process.killProcess(Process.myPid());
    }

}
