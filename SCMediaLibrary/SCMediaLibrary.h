#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

/*#define RELEASE
 
 #ifdef RELEASE
 #define NSLog(...)
 #else
 #define NSLog(...) NSLog(__VA_ARGS__);
 #endif
 
 
 #define DEVELOPMENT 1*/

/*  library  */
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIImageView+WebCache.h"
#import <math.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD-Prefix.pch"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Social/SLServiceTypes.h>
#import "AFNetworking.h"
#import "SCSocialProtocol.h"
#import "GPUImage.h"
#import "UIImage+BoxBlur.h"
#import "UIERealTimeBlurView.h"
#import <Twitter/Twitter.h>
#import "AFNetworking.h"
#import "NRGramKit.h"
#import "KKColor.h"
#import "Crittercism.h"


/* import all header files here */
#import "GMGridView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSDictionary+SCAdditions.h"
#import "NSMutableDictionary+SCAdditions.h"
#import "UIImage+ResizeMagick.h"
#import "UIView+SCAdditions.h"
#import "UIImage+BoxBlur.h"

// import all needed header
#import "SCConst.h"
#import "SCHelper.h"
#import "SCResourceDefine.h"
#import "SCNavigationController.h"

//import all manager
#import "SCBaseManager.h"
#import "SCFileManager.h"
#import "SCSocialProtocol.h"
#import "SCSocialManager.h"
#import "SCVineManager.h"
#import "SCEmailManager.h"
#import "SCMessageManager.h"
#import "SCSlideShowSettingManager.h"
#import "SCScreenManager.h"
#import "SCInstagramService.h"

//import all models
#import "SCModel.h"
#import "SCSlideModel.h"
#import "SCCompositionModel.h"
#import "SCVideoModel.h"
#import "SCSlideShowModel.h"
#import "SCTransitionModel.h"
#import "SCAudioModel.h"
#import "SCFilterModel.h"
#import "SCTextModel.h"
#import "SCVolumeRampModel.h"
#import "SCInstagramImage.h"
#import "SCInstagramUserModel.h"
#import "SCUploadObject.h"
#import "SCVineChannelModel.h"
#import "SCFacebookUploadObject.h"
#import "SCVineUploadObject.h"
#import "SCYouTubeUploadObject.h"
#import "SCTwitterUploadObject.h"


//import all views
#import "SCView.h"
#import "SCLoadingView.h"
#import "SCMediaItemView.h"
#import "SCItemGridView.h"
#import "SCItemGridViewCell.h"
#import "UIScrollViewEvent.h"
#import "SCViewController.h"
#import "SCRootViewController.h"
#import "KKColorListViewController.h"
#import "SCVideoPreview.h"

//import all composition
#import "SCComposition.h"
#import "SCMediaComposition.h"
#import "SCVideoComposition.h"
#import "SCSlideComposition.h"
#import "SCTextComposition.h"
#import "SCAudioComposition.h"
#import "SCFilterComposition.h"
#import "SCSlideShowComposition.h"
#import "SCVolumeRampComposition.h"
#import "SCLayerComposition.h"
#import "SCTransitionComposition.h"
#import "SCGraphicLayerComposition.h"
#import "SCParticleCompostion.h"


//import all builder
#import "SCMediaBuilderProtocol.h"
#import "SCBasicBuilderComposition.h"
#import "SCAdvancedBuilderComposition.h"
#import "SCSlideTransitionInstruction.h"
#import "SCBasicMediaBuilder.h"
#import "SCAdvancedMediaBuilder.h"

//import all exporter
#import "SCExporter.h"
#import "SCProjectExporter.h"
#import "SCMediaExporter.h"

//import all Utils
#import "SCJsonUtil.h"
#import "SCVideoUtil.h"
#import "SCImageUtil.h"
#import "SCUploadUtil.h"
#import "SCMediaFilterUtil.h"
#import "SCAudioUtil.h"

