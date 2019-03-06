THEOS_PLATFORM_DEB_COMPRESSION_LEVEL = 6

export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = puma
puma_FILES = Tweak.xm
puma_FRAMEWORKS = UIKit AVFoundation CoreTelephony AudioToolbox 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += pumaprefs
SUBPROJECTS += pumacc
include $(THEOS_MAKE_PATH)/aggregate.mk
