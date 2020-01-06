ARCHS = arm64 arm64e
TARGET = iphone:clang::11.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CercubeDarkMode
CercubeDarkMode_FILES = Tweak.xm
CercubeDarkMode_CFLAGS = -fobjc-arc
CercubeDarkMode_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
