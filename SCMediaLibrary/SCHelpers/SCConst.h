//
//  SCConst.h
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>


/* define social networks app id */
#define SC_INSTAGRAM_APP_ID @"f62cd98bbe524e7088d20def22b8dcd3"

/* define third party app id  */
#define SC_CRITERCISM_APP_ID @"52689f86a7928a3649000007"

/* define Google+ app id */

/* define Youtube App ID  */
#define SC_YOUTUBE_KEYCHAIN_ITEM_NAME   @"MagicVideo"
#define SC_YOUTUBE_APP_ID               @"1027897695473-o9itb271mrlb8bf755bgkubsslq52lp8.apps.googleusercontent.com"
#define SC_YOUTUBE_APP_SECRET           @"9AFL2TV24Jbfv0AvCn11R6HW"

#define SC_GOOGLE_PLUS_KEYCHAIN_ITEM_NAME   @"VideoRizeDemoGooglePlus"
// define enum of screens
/* define device id  */

#define CLIENT_DEVICE   @"1"

/* define const */

#define PI 3.14159265359
#define EPSILON 0.000001f
#define RADIAN_TO_DEGREE            180/PI
#define DEGREE_TO_RADIAN            PI/180
#define DEGREES_TO_RADIANS(x)       (M_PI * x / 180.0)
#define DELTA_TIME                  0.018
#define SC_IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


/* define constant for naming  */
#define SC_OUTPUT_VIDEO             @"output"
#define SC_OUTPUT_TEMP_FOLDER       @"tempDir"



/* define constant for media type - extension  */

#define SC_MOV              @"mov"
#define SC_MP4V             @"m4v"
#define SC_MP4              @"mp4"
#define SC_3GP              @"3gp"
#define SC_WAV              @"wav"
#define SC_MP3              @"mp3"
#define SC_M4A              @"m4a"
#define SC_CAF              @"caf"

#define SC_PNG              @"png"
#define SC_JPG              @"jpg"


#define SC_MEDIA_TYPE_MOV       AVFileTypeQuickTimeMovie
#define SC_MEDIA_TYPE_MPEG4     AVFileTypeMPEG4
#define SC_MEDIA_TYPE_M4V       AVFileTypeAppleM4V
#define SC_MEDIA_TYPE_3GP       AVFileType3GPP
#define SC_MEDIA_TYPE_WAV       AVFileTypeWAVE
#define SC_MEDIA_TYPE_MP3       AVFileTypeMPEGLayer3
#define SC_MEDIA_TYPE_M4A       AVFileTypeAppleM4A
#define SC_MEDIA_TYPE_CAF       AVFileTypeCoreAudioFormat


/* define constant for media compostion   */
#define SC_VIDEO_THUMBNAIL_SIZE                 CGSizeMake(60, 60)
#define SC_VIDEO_SIZE                           CGSizeMake(640, 640)
#define SC_VIDEO_VINE_SIZE                      CGSizeMake(480, 480)

#define SC_VIDEO_FPS                            30
#define SC_VIDEO_OUTPUT_FPS                     60
#define SC_VIDEO_BASIC_RENDER_FPS               24
#define SC_VIDEO_ADVANVCE_RENDER_FPS            60
#define SC_VIDEO_VINE_RENDER_FPS                5

#define SC_AUDIO_FADE_DEFAULT_DURATION          3
#define SC_AUDIO_BIT_RATE                       980000
#define SC_DEFAULT_TRANSITION_DURATION_SECOND   1
#define SC_DEFAULT_TRANSITION_DURATION          CMTimeMake(SC_DEFAULT_TRANSITION_DURATION_SECOND * SC_VIDEO_FPS, SC_VIDEO_FPS)
#define SC_THUMBNAIL_IMAGE_SIZE                 CGSizeMake(60, 60)
#define SC_THUMBNAIL_IMAGE_SIZE_RETINA          CGSizeMake(160, 160)
#define SC_SLIDE_ITEM_SIZE                      CGSizeMake(50,  50)
#define SC_TIMELINE_ITEM_SIZE                   CGSizeMake(70,  70)

#define SC_TIME_RULER_POINT_SIZE                CGSizeMake(30,  11)
#define SC_THUMBNAIL_PHOTO_VIEW_SIZE            CGSizeMake(160, 160)
#define SC_CROP_PHOTO_SIZE                      CGSizeMake(640, 640)
#define SC_PROJECT_DETAIL_ITEM_SIZE             CGSizeMake(303, 355)
#define SC_PROJECT_ITEM_SIZE                    CGSizeMake(148, 182)
#define SC_GRIDVIEW_INVALID_INDEX               -1
#define SC_GRIDVIEW_HEADER_HEIGHT               50

#define SC_PREVIEW_4INCH_SIZE                   CGSizeMake(266,266)
#define SC_PREVIEW_3INCH5_SIZE                  CGSizeMake(180,180)

#define SC_PREVIEW_4INCH_POSITION_DELTA         CGPointMake(7.5, 20)
#define SC_PREVIEW_3INCH5_POSITION_DELTA        CGPointMake(5, 10)

/* define video duration constant   */
#define SC_VIDEO_VINE_DURATION                  6
#define SC_VIDEO_INSTAGRAM_DURATION             15
#define SC_VIDEO_CUSTOM_DURATION                30

#define SC_VIDEO_CUSTOM_MIN_DURATION            1
#define SC_VIDEO_CUSTOM_MAX_DURATION            180

#define SC_VIDEO_TRANSITION_DURATION_0          0
#define SC_VIDEO_TRANSITION_DURATION_1          1
#define SC_VIDEO_TRANSITION_DURATION_1_5        1.5
#define SC_VIDEO_TRANSITION_DURATION_2          2

#define SC_VIDEO_MINIMUM_SLIDE_DURATION_1       1
#define SC_VIDEO_MINIMUM_SLIDE_DURATION_3       3
#define SC_VIDEO_MINIMUM_SLIDE_DURATION_4       4
#define SC_VIDEO_MINIMUM_SLIDE_DURATION_5       5

#define SC_CONNECTION_RATE                      60
#define SC_UPLOAD_BAR_PROGRESS_WIDTH            260


/*  define key constant for transit data */
#define SC_TRANSIT_KEY_SLIDE_ARRAY                              @"SC_TRANSIT_KEY_SLIDE_ARRAY"
#define SC_TRANSIT_KEY_SLIDE_SHOW_DATA                          @"SC_TRANSIT_KEY_SLIDE_SHOW_DATA"
#define SC_TRANSIT_KEY_SLIDE_DATA                               @"SC_TRANSIT_KEY_SLIDE_DATA"
#define SC_TRANSIT_KEY_SLIDE_DATA_INDEX                         @"SC_TRANSIT_KEY_SLIDE_DATA_INDEX"

#define SC_TRANSIT_KEY_SLIDE_SHOW_MODEL_ARRAY_DATA              @"SC_TRANSIT_KEY_SLIDE_SHOW_MODEL_ARRAY_DATA"
#define SC_TRANSIT_KEY_SLIDE_SHOW_THUMBNAIL_ARRAY               @"SC_TRANSIT_KEY_SLIDE_SHOW_THUMBNAIL_ARRAY"
#define SC_TRANSIT_KEY_SLIDE_SHOW_INDEX                         @"SC_TRANSIT_KEY_SLIDE_SHOW_INDEX"
#define SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_DATA              @"SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_DATA"
#define SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_MODEL             @"SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_MODEL"
#define SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_NAME              @"SC_TRANSIT_KEY_SLIDE_SHOW_COMPOSITION_NAME"
#define SC_TRANSIT_KEY_CHECK_FIRST_START                        @"SC_TRANSIT_KEY_CHECK_FIRST_START"


/* define key for setting*/
#define SC_SETTING_KEY_CHECK_FIRST_LAUNCH             @"SC_SETTING_KEY_CHECK_FIRST_LAUNCH"


/* define key constant for Vine */
#define SC_VINE_AUTHENTICATE_KEY                @"SC_VINE_AUTHENTICATE_KEY"
#define SC_VINE_EMAIL_KEY                       @"SC_VINE_EMAIL_KEY"
#define SC_VINE_PASSWORD_KEY                    @"SC_VINE_PASSWORD_KEY"

/* define notification key */
#define SCNotificationFinishLoadAllItem         @"SCNotificationFinishLoadAllItem"

/* define Sheet Menu size */
#define SC_SHEET_MENU_ITEM_WIDTH                271
#define SC_SHEET_MENU_ITEM_HEIGHT               44
#define SC_SHEET_MENU_ICON_WIDTH                30
#define SC_SHEET_MENU_ICON_HEIGHT               30
#define SC_SHEET_MENU_ITEM_COLOR                            [UIColor colorWithRed:52.0/225.0 green:170.0/225.0 blue:220.0/225.0 alpha:1.0]
#define SC_SHEET_MENU_ITEM_HIGHLIGHT_COLOR                  [UIColor colorWithRed:147.0/225.0 green:208.0/225.0 blue:234.0/225.0 alpha:1.0]
#define SC_SHEET_MENU_ITEM_CANCEL_COLOR                     [UIColor colorWithRed:254.0/225.0 green:70.0/225.0 blue:105.0/225.0 alpha:1.0]
#define SC_SHEET_MENU_ITEM_CANCEL_HIGHLIGHT_COLOR           [UIColor colorWithRed:248.0/225.0 green:160.0/225.0 blue:177.0/225.0 alpha:1.0]

#define SC_VINE_COLOR                                       [UIColor colorWithRed:29.0/225.0 green:190.0/225.0 blue:144.0/225.0 alpha:1.0]

/* define enum of screens */

#define SC_TEXT_FONT_NAME_DEFAULT                       @"HelveticaNeue"
#define SC_FONT_DEFAULT                                 @"Fujiyama"


typedef enum {
    SCEnumNoneScreen,
    SCEnumTestScreen,
    SCEnumStartScreen,
    SCEnumHomeScreen,
    SCEnumPhotosScreen,
    SCEnumPhotoGridViewScreen,
    SCEnumPhotosPickerScreen,
    SCEnumPhotoCropScreen,
    SCEnumPhotoCaptureScreen,
    SCEnumEditorScreen,
    SCEnumPlayScreen,
    SCEnumGalleryScreen,
    SCEnumProjectDetailScreen,
    SCEnumCameraRollScreen,
    SCEnumExportScreen,
    SCEnumSettingScreen,
    SCEnumUploadManagerScreen,
    SCEnumSinglePhotoPickerScreen,
    SCEnumPhotoAlbumScreen,
    SCEnumPhotoManageScreen,
    SCEnumInstagramAuthenticateScreen,
    SCEnumVineAuthenticateScreen,
    SCEnumPreviewScreen,
    SCEnumEffectScreen,
    SCEnumVideoLengthSettingScreen,
    SCEnumSharingScreen,
    SCEnumLoginScreen,
    SCEnumEditVideoScreen,
    SCEnumHelpScreen,
    SCEnumShareScreen
} SCEnumScreen;


/* define enum of editors */


typedef enum {
    SCEnumTextEditor,
    SCEnumFilterEditor,
    SCEnumAudioEditor,
    SCEumRecordEditor,
} SCEnumEditor;

/* Define enum of media trak  */

typedef enum {
	SCVideoTrack = 0,
    SCTextTrack,
	SCCommentaryTrack,
	SCMusicTrack,
    SCRecordAudioTrack,
} SCTrack;

/* Define enum of video orientation  */

typedef enum {
    SCVideoOrientationNone,
	SCVideoOrientationPotrait,
	SCVideoOrientationLanscapeLeft,
    SCVideoOrientationLanscapeRight,
    SCVideoOrientationUpsideDown ,

} SCVideoOrientation;


/* Define enum of media play status  */

typedef enum {
    SCMediaStatusPlay,
    SCMediaStatusPause,
    SCMediaStatusStop,
    SCMediaStatusUnknow,
    SCMediaStatusSeeking

} SCMediaStatus;

/* define enum of grid view */

typedef enum  {
    SCGridViewTypeVertical,
    SCGridViewTypeHorizontal,
    SCGridViewTypeLargeVertical,
    SCGridViewTypeLargeHorizontal,
    
}SCGridViewType;


/* define text alignment  */
typedef enum {
    
    SCEnumTextAlignmentLeft,
    SCEnumTextAlignmentCenter,
    SCEnumTextAlignmentRight,
    
}SCTextAlignment;

/* define transition  */
typedef enum {
	SCVideoTransitionTypeNone = 0,
	SCVideoTransitionTypeFadeIn,
	SCVideoTransitionTypeFadeOut,
	SCVideoTransitionTypeDisolve,
	SCVideoTransitionTypePush,
    SCVideoTransitionTypePushFromTop,
	SCVideoTransitionTypePushFromBottom,
	SCVideoTransitionTypePushFromLeft,
	SCVideoTransitionTypePushFromRight,
    SCVideoTransitionTypeZoomIn,
    SCVideoTransitionTypeZoomOut,
} SCVideoTransitionType;

typedef enum {
	SCPushTransitionDirectionLeftToRight = 0,
	SCPushTransitionDirectionRightToLeft,
	SCPushTransitionDirectionTopToButton,
	SCPushTransitionDirectionBottomToTop,
	SCPushTransitionDirectionInvalid = INT_MAX
} SCPushTransitionDirection;


/* define enum of settings */
typedef enum {
    SCAccountInstagram  = 0,
    SCAccountFacebook   = 1,
    SCAccountYoutube    = 2,
    SCAccountVine       = 3
} SCAccount;


/* define enum of project duration type */
typedef enum {
    SCVideoDurationTypeVine,
    SCVideoDurationTypeInstagram,
    SCVideoDurationTypeCustom
} SCVideoDurationType;


typedef enum {
    SCShareTypeEmail        = 0,
    SCShareTypeiMessage     = 1,
    SCShareTypeFacebook     = 2,
    SCShareTypeTwitter      = 3,
    SCShareTypeGooglePlus   = 4
} SCShareType;

/* define enum Camera Flash Mode */
typedef enum {
    CameraFlashModeAuto = 0,
    CameraFlashModeON   = 1,
    CameraFlashModeOFF  = 2
} CameraFlashMode;

/* define enum Image Filter Mode */
typedef enum {
    SCImageFilterModeNormal       = 0,
} SCImageFilterMode;

/* define enums for Upload */
typedef enum {

    SCUploadTypeNone        = 1000,
    SCUploadTypeCameraRoll  = 0,
    SCUploadTypeFacebook    = 1,
    SCUploadTypeYoutube     = 2,
    SCUploadTypeVine        = 3,
    SCUploadTypeEmail       = 4,
    SCUploadTypeiMessage    = 5,
    SCUploadTypeVimeo       = 6,
    SCUploadTypeInstagram   = 7,
    SCUploadTypeTwitter     = 8,
    SCUploadTypeMore        = 9,

    

} SCUploadType;
typedef enum {
    SCUploadStatusUnknown       = 0,
    SCUploadStatusUploaded      = 1,
    SCUploadStatusUploading     = 2,
    SCUploadStatusFailed        = 3,
} SCUploadStatus;

static const NSUInteger SLIDE_SHOW_SECONDS = 30;
static const NSUInteger SLIDE_SHOW_WIDTH = 640;


/* define UI Color constant */
#define SC_STRING_COLOR_RED             [UIColor colorWithRed:233.0/255.0 green:80.0/255.0 blue:23.0/255.0 alpha:1.0]
#define SC_STRING_COLOR_ORANGE          [UIColor colorWithRed:255.0/255.0 green:174.0/255.0 blue:0.0/255.0 alpha:1.0]
#define SC_STRING_COLOR_ORANGE_IPHONE   [UIColor colorWithRed:234.0/255.0 green:142.0/255.0 blue:0.0/255.0 alpha:1.0]
#define SC_STRING_COLOR_GRAY            [UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]

/*  define string api */


/* define local notification */

#define SCNotificationDidFinishSelectPhotos                   @"SCNotificationDidFinishSelectPhotos"
#define SCNotificationDidFinishHelpPresent                    @"SCNotificationDidFinishHelpPresent"

/* define social manager notifications */

// instagram
#define SCNotificationInstagramDidLogIn                 @"SCNotificationInstagramDidLogIn"
#define SCNotificationInstagramDidLogOut                @"SCNotificationInstagramDidLogOut"
#define SCNotificationInstagramDidLoadPhoto             @"SCNotificationInstagramDidLoadPhoto"
#define SCNotificationInstagramDidLoadMorePhoto         @"SCNotificationInstagramDidLoadMorePhoto"
#define SCNotificationInstagramDidLoadMorePhotoFailed   @"SCNotificationInstagramDidLoadMorePhotoFailed"

#define SCNotificationInstagramDidLogInAlbumList        @"SCNotificationInstagramDidLogInAlbumList"
#define SCNotificationInstagramDidLogInWhileDismissing  @"SCNotificationInstagramDidLogInWhileDismissing"

#define SCNotificationInstagramDidFailedLoadMorePhoto   @"SCNotificationInstagramDidFailedLoadMorePhoto"

#define SCInstagramRequestLogin                         @"SCInstagramRequestLogin"
#define SCInstagramRequestPhoto                         @"SCInstagramRequestPhoto"
#define SCInstagramRequestMorePhoto                     @"SCInstagramRequestMorePhoto"

// facebook
#define SCNotificationFacebookDidLogIn                  @"SCNotificationFacebookDidLogIn"
#define SCNotificationFacebookShared                    @"SCNotificationFacebookShared"
#define SCNotificationFacebookDidLogOut                 @"SCNotificationFacebookDidLogOut"


#define SCNotificationFacebookDidLogInForShareVideo     @"SCNotificationFacebookDidLogInForShareVideo"

// youtube
#define SCNotificationYoutubeDidLogIn                   @"SCNotificationYoutubeDidLogIn"
#define SCNotificationYoutubeDidLogOut                  @"SCNotificationYoutubeDidLogOut"
#define SCNotificationYoutubeDidLogInForUpload          @"SCNotificationYoutubeDidLogInForUpload"

// google plus
#define SCNotificationGooglePlusDidLogIn                @"SCNotificationGooglePlusDidLogIn"
#define SCNotificationGooglePlusDidLogOut               @"SCNotificationGooglePlusDidLogOut"
#define SCNotificationGooglePlusShared                  @"SCNotificationGooglePlusShared"
#define SCNotificationGooglePlusShareFailed             @"SCNotificationGooglePlusShareFailed"

// send email
#define SCNotificationEmailDidSent                      @"SCNotificationEmailDidSent"
#define SCNotificationEmailSentFailed                   @"SCNotificationEmailSentFailed"

// send message
#define SCNotificationMessageDidSent                    @"SCNotificationMessageDidSent"
#define SCNotificationMessageSentFailed                 @"SCNotificationMessageSentFailed"

// send Twitter
#define SCNotificationTwitterDidSent                    @"SCNotificationTwitterDidSent"
#define SCNotificationTwitterSentFailed                 @"SCNotificationTwitterSentFailed"

// send Vine
#define SCNotificationVineDidLoginIn                    @"SCNotificationVineDidLoginIn"
#define SCNotificationVineDidLogInForUpload             @"SCNotificationVineDidLogInForUpload"
#define SCNotificationVineDidLogOut                     @"SCNotificationVineDidLogOut"
#define SCNotificationVineDidCancelLoginIn              @"SCNotificationVineDidCancelLoginIn"
#define SCNotificationVineDidFailedLogIn                @"SCNotificationVineDidFailedLogIn"

#define SC_SHARE_NUMBER_EMAIL_KEY                       @"SC_SHARE_NUMBER_EMAIL_KEY"
#define SC_SHARE_NUMBER_MESSAGE_KEY                     @"SC_SHARE_NUMBER_MESSAGE_KEY"
#define SC_SHARE_NUMBER_FACEBOOK_KEY                    @"SC_SHARE_NUMBER_FACEBOOK_KEY"
#define SC_SHARE_NUMBER_TWITTER_KEY                     @"SC_SHARE_NUMBER_TWITTER_KEY"
#define SC_SHARE_NUMBER_GOOGLE_PLUS_KEY                 @"SC_SHARE_NUMBER_GOOGLE_PLUS_KEY"
