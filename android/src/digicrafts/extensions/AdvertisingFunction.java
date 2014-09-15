package digicrafts.extensions;

import android.util.Log;
import com.adobe.fre.*;
import digicrafts.extensions.core.AbstractAdAdapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public abstract class AdvertisingFunction<T> implements FREFunction {

    private String name;
    private Class<?>[] argTypes;

    public AdvertisingFunction(String name, Class<?>... classes) {
        this.name = name;
        this.argTypes = classes;
    }

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        AdvertisingContext cbCx = (AdvertisingContext)context;
        try {
            T ret = onCall(cbCx, convertArgs(args));
            if (ret == null)
                return null;
            else if (ret.getClass() == Boolean.class)
                return FREObject.newObject((Boolean)ret);
            else if (ret.getClass() == String.class)
                return FREObject.newObject((String)ret);
            else if (Integer.class.isInstance(ret))
                return FREObject.newObject((Integer)ret);
            else if (Double.class.isInstance(ret))
                return FREObject.newObject((Double)ret);
            else if (Number.class.isInstance(ret))
                return FREObject.newObject(Double.valueOf(ret.toString()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Object[] convertArgs(FREObject[] args)
            throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException {
        if (args == null)
            return null;

        Object[] ret = new Object[args.length];
        try {

            for (int i = 0; i < args.length; i++) {

                if (args[i] == null)
                    ret[i] = null;
                else if (argTypes[i] == String.class)
                    ret[i] = args[i].getAsString();
                else if (argTypes[i] == Integer.class)
                    ret[i] = args[i].getAsInt();
                else if (argTypes[i] == Double.class)
                    ret[i] = args[i].getAsDouble();
                else if (argTypes[i] == Boolean.class)
                    ret[i] = args[i].getAsBool();
                else if (argTypes[i] == AbstractAdAdapter.class)
                {
//                    Log.d("DEBUG","Get Settings");
                    // Convert the adapter settings
                    FREArray settingsRaw = (FREArray) args[i];
//                    Log.d("DEBUG","Get Settings 2: "+settingsRaw.toString());
                    FREArray settingsName = (FREArray) settingsRaw.getObjectAt(0);
//                    Log.d("DEBUG","Get Settings 3");
                    FREArray settingsType = (FREArray) settingsRaw.getObjectAt(1);
//                    Log.d("DEBUG","Get Settings 4");
                    FREObject settingsValue = settingsRaw.getObjectAt(2);
                    long len = settingsName.getLength();
//                    Log.d("DEBUG","Get Settings 5");
                    Map<String, Object> settings = new HashMap<String, Object>();

//                    Log.d("DEBUG","Get Settings 6");
                    // Loop each property
                    for (int j = 0; j < len; j++) {

                        String type = settingsType.getObjectAt(j).getAsString();
                        String name = settingsName.getObjectAt(j).getAsString();

//                        Log.d("ADDEBUG",name+" : "+name);

                        FREObject value = settingsValue.getProperty(name);

//                        Log.d("ADDEBUG",name+" : "+type + " value:");

                        if(type.equals("string"))
                            settings.put(name,value.getAsString());
                        else if(type.equals("int"))
                            settings.put(name,value.getAsInt());
                        else if(type.equals("number"))
                            settings.put(name,value.getAsDouble());
                        else if(type.equals("boolean"))
                            settings.put(name,value.getAsBool());
                        else if(type.equals("array_string")){

                            FREArray arraystring=(FREArray) value;
                            ArrayList<String> a = new ArrayList<String>();
                            long l = arraystring.getLength();

                            for (int k = 0; k < l; k++) {
                                a.add(arraystring.getObjectAt(k).getAsString());
                            }
                            settings.put(name,a);
                        }
                    }
                    ret[i] = settings;
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return ret;
    }

    public abstract T onCall(AdvertisingContext context, Object[] args)
            throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException;

    public String getName() {
        return name;
    }

}
