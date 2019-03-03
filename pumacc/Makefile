include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64

BUNDLE_NAME = pumacc
pumacc_BUNDLE_EXTENSION = bundle
pumacc_FILES = pumacc.m
pumacc_PRIVATE_FRAMEWORKS = ControlCenterUIKit
pumacc_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk
