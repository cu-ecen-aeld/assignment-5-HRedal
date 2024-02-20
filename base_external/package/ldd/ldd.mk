################################################################################
#
# ldd3
#
################################################################################

LDD_VERSION = v2.6.37
LDD_SITE = https://github.com/cu-ecen-aeld/ldd3.git
LDD_SITE_METHOD = git
LDD_LICENSE = GPL-2.0
LDD_LICENSE_FILES = COPYING
LDD_GIT_SUBMODULES=yes
LDD_MODULE_SUBDIRS = scull
LDD_MODULE_SUBDIRS += misc-modules
LDD_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
define LDD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(@D)/scull/scull_load   $(TARGET_DIR)/sbin/
	$(INSTALL) -m 0755 $(@D)/scull/scull_unload $(TARGET_DIR)/sbin/
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_load   $(TARGET_DIR)/bin/
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_unload $(TARGET_DIR)/bin/misc-modules/
endef

$(eval $(kernel-module))
$(eval $(generic-package))
