THEOS_PLATFORM_DEB_COMPRESSION_LEVEL = 6

# ARCHS = armv7 arm64
ARCHS = x86_64
DEBUG = 1
TARGET = simulator:clang::7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = puma
puma_FILES = Tweak.xm
puma_FRAMEWORKS = UIKit AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
