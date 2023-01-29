package x.y.z;

import android.os.IBinder;
import android.os.RemoteException;
import r.s.aidlInterface;

public class IClass extends aidlInterface.Stub {

    @Override
    public IBinder asBinder() {
        return this;
    }

    @Override
    public String z() throws RemoteException {
        return new h().ss("x.y.z");
    }
}