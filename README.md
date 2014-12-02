Advertising Native Extension for Adobe Air
=========

This Advertising ANE add supprt to using all major mobile system and popular adverting network with Adobe Air. Supports IOS, Android and Kindle.

Brought to you by the [Indiegogo Campaign](https://www.indiegogo.com/projects/universal-advertising-air-native-extension/x/4441429).

Thanks to our Backers.

* Michał Moczyński [link](https://www.indiegogo.com/individuals/8561839/x/4441429)
* Marcus Frasier [link](https://www.indiegogo.com/individuals/2120782/x/4441429)
* dwight.eppinger

##Support

This is an open source software. We welcome any contribution and you can send us feedback or features requests in the issues section. But we don't guarantee we can answer all your questions.

> Your kind donations will help us pause my daily job and put more serious effort into the development of this software for the future updates. Thanks.
>
> <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EAPDTXAME7DMU" target="_blank"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" alt="[paypal]" /></a>

If you need a dedicated support service for using this software, you can contact us at support[at]digicrafts.com.hk. We also provide software development services and you can contact us with email.

##Version History

1.0
First public release

##Highlighted Features

The Universal Advertising AIR native extension will include the following highlighted features:

* Supporting Android/IOS/Kindle
* Supporting major advertising network
* Banner and interstitial ads
* Auto orientation
* Setting priority of each advertising network
* Backfill ads with bitmap or external images
* Simple API and minimal coding needed. 

##Supported Advertising Network

The current supporting network are list below:

* Google Mobile Ads (AdMob) (ios 6.11.1/newest google play services)
* iAd (IOS only/Compile with IOS SDK 8.1)
* MillennialMedia (ios 5.4.1/android 5.3.0)
* InMobi (ios 4.5.1/android 4.5.1)
* Amazon Mobile Ads (ios 2.1.4/android 5.4.78)
* Static backfill in house ads (via external images)
* Platform supporting via AdMob Mediation Networks

##Install the library

Add the AmazonAds-ANE library to your project.

In Flash Professional CS6:

  1. Create a new mobile project
  2. Choose File > PublishSettings... 
  3. Select the wrench icon next to 'Script' for 'ActionScriptSettings' 
  4. Select the Library Path tab. 
  5. Click 'Browse for Native Extension(ANE) File' and select the Mopub.ane file. 

In Flash Builder 4.6:

  1. Goto Project Properties
  2. Select Native Extensions under Actionscript Build Path
  3. Choose Add ANE... and navigate to the Mopub.ane file 
  4. Select Actionscript Build Packaging > Google Android or Apple IOS
  5. Select the Native Extensions tab, and click the 'Package' check box next to the extension

In Flash Professional CS5.5 or Lower:

  1. Select File>PublishSettings>Flash>ActionScript 3.0 Settings 
  2. Select External Library Path
  3. Click Browseto SWC File
  4. Select the Mopub.swc

In Flash Builder 4.5:

  1. Goto Project Properties
  2. Select Action Script Build Path
  3. Select Add Swc
  4. Navigate to Mopub.swc and choose External Library type

In FlashDevelop:

  1. Copy the Mopub.swc file to your project folder.
  2. In the explorer panel, right click the .swc and select Add to Library.
  3. Right-click the swc file in the explorer, choose Options, and select External Library

##Add the Actionscript

Import the library

```javascript
import digicrafts.extensions.Advertising;
import digicrafts.extensions.core.AdSettings;
import digicrafts.extensions.data.*;
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.events.*;
```

Create a settings object. And add the adapter for different network.

```javascript       
// Create a setting instance for the banner         
var settings:AdSettings= new AdSettings();

// Manual create adapter
// AdMob
var adMob:AdMobAdapter=new AdMobAdapter('AD-UNIT-ID');
// Amazon
var amazon:AmazonAdapter=new AmazonAdapter('APP_ID');        
// iAd
var iAd:IAdAdapter=new IAdAdapter();
// Backfill
// * Remember to include banner images when you packaging the app
var backfill:BackFillAdapter=new BackFillAdapter('http://www.google.com');
backfill.interstitial="BANNER.png";
backfill.banner="BANNER.png";
backfill.full_banner="FULL_BANNER.png";
backfill.leaderboard="LEADERBOARD.png";
backfill.medium_rectangle="MEDIUM_RECTANGLE.png";

// Add the adapter to the settings
settings.add(adMob,2);
settings.add(amazon,1);
settings.add(iAd,3);
settings.add(backfill,4);
```

If you want to load test ads, you can set the testMode property.

```javascript
  Advertising.testMode=true;
```

Create a banner and load. Supply an unique name and size for each banner.

```javascript
  Advertising.getBanner('BANNER_1',AdSize.BANNER,settings);
```

You can also show the banner immediately. Supply the position and refresh rate.

```javascript
  Advertising.getBanner('BANNER_1',AdSize.BANNER,settings).show(AdPosition.BOTTOM,30);
```

Supported positions.

* AdPosition.BOTTOM
* AdPosition.BOTTOM_LEFT
* AdPosition.BOTTOM_RIGHT
* AdPosition.TOP
* AdPosition.TOP_LEFT
* AdPosition.TOP_RIGHT
* AdPosition.CENTER

Remove the banner from screen.

```javascript
  Advertising.getBanner('BANNER_1').remove();
```

Create an interstitial and load.

```javascript
  Advertising.getInterstitial('INTERSTITIAL_1',AdSize.BANNER,settings);
```

Show the Interstitial Ad. Supply the frequency to appear. Also, you can specify the max count to show.

```javascript
  Advertising.getInterstitial('INTERSTITIAL_1').show(3,2);
```

You can listen to the event by adding a listener to the Advertising instance.

```javascript
function handleAdEvent(e:AdEvent):void{

 // e.data contains the raw event data

 // e.ad contains the ad instance for the event 

}
Advertising.getInstance().addEventListener(AdEvent.AD_LOADED, handleAdEvent );
```

Supported events.

- *AdEvent.AD_LOADED*               
    -Event type for ad loaded.
- *AdEvent.AD_WILL_PRESENT*         
    -Event type for ad will going to show on screen.
- *AdEvent.AD_DID_PRESENT*          
    -Event type for ad did show on screen.
- *AdEvent.AD_WILL_DISMISS*         
    -Event type for ad will remove from screen.
- *AdEvent.AD_DID_DISMISS*          
    -Event type for ad did remove from screen.
- *AdEvent.AD_FAILED_TO_LOAD*       
    -Event type for ad did fail to load.
- *AdEvent.WILL_LEAVE_APPLICATION*  
    -Event type for ad did fail to load.
     

##Setup for Android

> *Important Notice:* Since the current AIR SDK (<15.0) use an old version build tools and it is not compatialbe 
> with the recent Google Play Service library. It lead to a class missing exception when using AdMob adapter.
> To fix, copy the dx.jar from the new Android SDK to the AIR SDK. 

Update Your Application Descriptor

You'll need to be using the AIR 14.0 SDK or higher, include the extension in your Application Descriptor XML, and update the Android Manifest Additions with some settings.

Add the following settings in <application> tag.

```xml
<!-- Google Play -->
<meta-data android:name="com.google.android.gms.version"
    android:value="@integer/google_play_services_version"/>
<activity android:name="com.google.android.gms.ads.AdActivity"
    android:theme="@android:style/Theme.Translucent"
    android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize"/>

<!-- Amazon Mobile Ads -->
<activity android:name="com.amazon.device.ads.AdActivity"
    android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- Millennial Media -->
<activity android:name="com.millennialmedia.android.MMActivity"
    android:theme="@android:style/Theme.Translucent.NoTitleBar"
    android:configChanges="keyboardHidden|orientation|keyboard|screenSize" ></activity>

<!-- InMobi -->
<activity android:name="com.inmobi.androidsdk.IMBrowserActivity"
    android:configChanges="keyboardHidden|orientation|keyboard|smallestScreenSize|screenSize"
    android:theme="@android:style/Theme.Translucent.NoTitleBar"
    android:hardwareAccelerated="true" />
```
Add the following basic permissions.

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

Add the following permission if you want video interstitial supported (millennialmedia).

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-feature android:name="android.hardware.microphone" android:required="false" />
```

Add the following permission if you want the ad target location.

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

##Developer

The software is developed by Digicrafts.

http://www.facebook.com/DigicraftsComponents

http://www.digicrafts.com.hk/components

##License

This project is licensed under the BSD license [link](https://github.com/digicrafts/Advertising-ANE/blob/master/LICENSE)
