package x.y.z;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;

public class m extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_m);

        ImageButton button = findViewById(R.id.btn);
        button.setOnClickListener(view -> startActivity(new Intent(m.this,a.class)));

    }
}