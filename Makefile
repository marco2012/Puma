THEOS_PLATFORM_DEB_COMPRESSION_LEVEL = 6

# ARCHS = armv7 arm64
export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64
# ARCHS = x86_64
# DEBUG = 1
# TARGET = simulator:clang::7.0
# TARGET = iphone::12.1.2:9.0
# ARCHS = arm64
# SDKVERSION = 9.3
# SYSROOT = $(THEOS)/sdks/iPhoneOS9.3.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = puma
puma_FILES = Tweak.xm
puma_FRAMEWORKS = UIKit AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += pumaprefs
SUBPROJECTS += pumacc
include $(THEOS_MAKE_PATH)/aggregate.mk
