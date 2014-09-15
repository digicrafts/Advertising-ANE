/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.core {

import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.Advertising;
import digicrafts.extensions.data.AdPosition;
import digicrafts.extensions.data.AdSize;

public class AdBanner extends Ad {

    private var _position:String;
    private var _offsetX:int;
    private var _offsetY:int;

    public function AdBanner(setting:AdSettings, id:String, size:String=AdSize.BANNER) {

        super(setting, id, size);
    }

    /**
     * Display the ads in position on the screen
     * @param position
     * @param refresh
     * @param offsetX
     * @param offsetY
     */
    public function show(position:String=AdPosition.BOTTOM,refresh:int=-1,offsetX:int=0,offsetY:int=0):void
    {

        _position=position;
        _offsetX=offsetX;
        _offsetY=offsetY;
        if(refresh==-1) refresh=Advertising.defaultBannerRefresh;
        if(refresh>0) ad_internal::refresh=refresh*1000;

        _show(position,int(offsetX),int(offsetY));
    }

//    /**
//     * Display the ads in X/Y position on the screen
//     * @param x
//     * @param y
//     * @param refresh
//     */
//    public function showXY(x:int=0, y:int=0, refresh:int=-1):void
//    {
//        if(refresh==-1) refresh=Advertising.defaultBannerRefresh;
//        if(refresh>0) ad_internal::refresh=refresh*1000;
//
//        _show(AdPosition.FLOAT,int(x),int(y));
//    }

    /**
     * @override
     */
    override public function refresh():void
    {
        if(_position){
//            show(_position);
        }
    }

    /**
     * @override
     */
    override protected function _next():void
    {
        super._next();

        if(setting) {

            if(visible)
                _show(_position, _offsetX, _offsetY);
            else
                _load();
        }
    }

}
}
