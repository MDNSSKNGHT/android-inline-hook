LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := shadowhook
LOCAL_SRC_FILES := \
	sh_enter.c \
	sh_exit.c \
	sh_hub.c \
	sh_jni.c \
	sh_linker.c \
	sh_recorder.c \
	sh_safe.c \
	sh_switch.c \
	sh_task.c \
	shadowhook.c \
	common/bytesig.c \
	common/sh_errno.c \
	common/sh_log.c \
	common/sh_trampo.c \
	common/sh_util.c \
	third_party/xdl/xdl.c \
	third_party/xdl/xdl_iterate.c \
	third_party/xdl/xdl_linker.c \
	third_party/xdl/xdl_lzma.c \
	third_party/xdl/xdl_util.c
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_SRC_FILES += \
	arch/arm/sh_a32.c \
	arch/arm/sh_inst.c \
	arch/arm/sh_t16.c \
	arch/arm/sh_t32.c \
	arch/arm/sh_txx.c
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
LOCAL_SRC_FILES += \
	arch/arm64/sh_a64.c \
	arch/arm64/sh_inst.c
endif
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/. \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/common \
	$(LOCAL_PATH)/third_party/xdl \
	$(LOCAL_PATH)/third_party/bsd \
	$(LOCAL_PATH)/third_party/lss
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/arch/arm
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/arch/arm64
endif
LOCAL_LDLIBS := -llog
LOCAL_CFLAGS := -std=c17 -Weverything #-Werror

ifdef USEASAN
LOCAL_CFLAGS += -fsanitize=address -fno-omit-frame-pointer
LOCAL_LDFLAGS += -fsanitize=address
else
LOCAL_CFLAGS += -flto -faddrsig -ffunction-sections -fdata-sections
LOCAL_LDFLAGS += -flto -Wl,--icf=all -Wl,-mllvm,--enable-machine-outliner=always -Wl,--exclude-libs,ALL -Wl,--gc-sections -Wl,--version-script=$(LOCAL_PATH)/shadowhook.map.txt
endif

include $(BUILD_SHARED_LIBRARY)
