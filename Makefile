THEOS_DEVICE_IP = 0
THEOS_DEVICE_PORT = 2222
TARGET = iphone:11.2:8.0
ARCHS = arm64 armv7s armv7
LDFLAGS = -lobjc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SuperUser
SuperUser_FILES = $(wildcard SuperSUiOS/*.m) Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	@echo "Reminder: You MUST restart SpringBoard after installing this tweak. Otherwise the observer will not be registered and setuid apps will crash."
	install.exec "killall -9 SpringBoard || true"