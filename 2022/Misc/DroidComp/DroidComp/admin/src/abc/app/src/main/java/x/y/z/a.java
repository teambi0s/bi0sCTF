package x.y.z;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.URLUtil;
import android.webkit.WebView;

public class a extends AppCompatActivity {

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_a);

        WebView w = findViewById(R.id.webView);
        w.getSettings().setJavaScriptEnabled(true);
        w.addJavascriptInterface(new c(this),"client");
        w.getSettings().getAllowFileAccess();
        w.getSettings().getAllowContentAccess();
        w.getSettings().getAllowUniversalAccessFromFileURLs();
        w.getSettings().getDomStorageEnabled();
        w.getSettings().setUseWideViewPort(true);
        w.getSettings().setAppCacheEnabled(true);
        w.getSettings().setAllowFileAccess(true);

        Intent i = getIntent();
        if(i == null)
            w.loadUrl("https://google.com");

        assert i != null;

        Uri u = i.getData();

        if(u != null){
            String parameters = u.getQueryParameter("web");
            Log.d("TAG", "onCreate: "+parameters);
            if(parameters != null & URLUtil.isValidUrl(parameters)){
                w.loadUrl(parameters);
            }else {
                assert parameters != null;
                if(parameters.contains("html")){
                    w.loadUrl(parameters);
                }
            }
        }else{
            w.loadUrl("https://google.com");
        }

    }
}