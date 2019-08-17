.NOTPARALLEL:

# If we haven't got IDF_PATH set already, reinvoke with IDF_PATH in the environ
ifeq ($(IDF_PATH),)
THIS_MK_FILE:=$(notdir $(lastword $(MAKEFILE_LIST)))
THIS_DIR:=$(abspath $(dir $(lastword $(MAKEFILE_LIST))))
IDF_PATH=$(THIS_DIR)/sdk/nonos-sdk-idf

TOOLCHAIN_VERSION:=20181106.0
PLATFORM:=linux-x86_64

ESP8266_BIN:=$(THIS_DIR)/tools/toolchains/esp8266-$(PLATFORM)-$(TOOLCHAIN_VERSION)/bin
ESP8266_GCC:=$(ESP8266_BIN)/xtensa-lx106-elf-gcc
ESP8266_TOOLCHAIN_DL:=$(THIS_DIR)/cache/toolchain-esp8266-$(PLATFORM)-$(TOOLCHAIN_VERSION).tar.xz

all: | $(ESP8266_GCC)
%: | $(ESP8266_GCC)
	@echo Setting IDF_PATH and re-invoking...
	@env IDF_PATH=$(IDF_PATH) PATH=$(ESP8266_BIN):$(PATH) $(MAKE) -f $(THIS_MK_FILE) $@
	@if test "$@" = "clean"; then rm -rf $(THIS_DIR)/tools/toolchains/esp8266-*; fi

$(ESP8266_GCC): $(ESP8266_TOOLCHAIN_DL)
	@echo Uncompressing toolchain
	@mkdir -p $(THIS_DIR)/tools/toolchains/
	@tar -xJf $< -C $(THIS_DIR)/tools/toolchains/
	# the archive contains ro files
	@chmod -R u+w $(THIS_DIR)/tools/toolchains/esp8266-*
	@touch $@

$(ESP8266_TOOLCHAIN_DL):
	@mkdir -p $(THIS_DIR)/cache
	wget --tries=10 --timeout=15 --waitretry=30 --read-timeout=20 --retry-connrefused https://github.com/jmattsson/esp-toolchains/releases/download/$(PLATFORM)-$(TOOLCHAIN_VERSION)/toolchain-esp8266-$(PLATFORM)-$(TOOLCHAIN_VERSION).tar.xz -O $@ || { rm -f "$@"; exit 1; }

else

PROJECT_NAME:=example-app

include $(IDF_PATH)/make/project.mk

endif
