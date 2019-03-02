include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = pumaprefs
pumaprefs_FILES = pumaprefsRootListController.m
pumaprefs_INSTALL_PATH = /Library/PreferenceBundles
pumaprefs_FRAMEWORKS = UIKit
pumaprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/pumaprefs.plist$(ECHO_END)
