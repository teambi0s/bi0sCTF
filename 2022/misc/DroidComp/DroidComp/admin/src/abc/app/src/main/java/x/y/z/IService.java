package x.y.z;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;

import r.s.aidlInterface;

public class IService extends Service {
    private IClass iclass = new IClass();

    @Override
    public IBinder onBind(Intent intent) {
        return iclass;
    }


}