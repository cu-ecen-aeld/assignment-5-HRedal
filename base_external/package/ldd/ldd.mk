################################################################################
#
# ldd3
#
################################################################################

LDD_VERSION = 5cff85c900f7577e2c5e38abe5d6027eac5b0872
LDD_SITE = git@github.com:cu-ecen-aeld/assignment-7-HRedal.git
LDD_SITE_METHOD = git
LDD_LICENSE = GPL-2.0
LDD_LICENSE_FILES = COPYING
LDD_GIT_SUBMODULES=yes
LDD_MODULE_SUBDIRS = scull
LDD_MODULE_SUBDIRS += misc-modules
LDD_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)

define LDD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/scull/scull_load   $(TARGET_DIR)/sbin/
 	$(INSTALL) -m 0755 $(@D)/scull/scull_unload $(TARGET_DIR)/sbin/
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_load   $(TARGET_DIR)/sbin/
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_unload $(TARGET_DIR)/sbin/
endef

$(eval $(kernel-module))
$(eval $(generic-package))
