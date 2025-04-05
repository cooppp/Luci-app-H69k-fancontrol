include $(TOPDIR)/rules.mk

PKG_NAME:=fanctrl
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Your Name <your@email.com>
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/fanctrl
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Intelligent Fan Control Daemon
  DEPENDS:=+bash
  PKGARCH:=all
endef

define Package/fanctrl/description
  Adaptive PWM fan control with temperature monitoring.
endef

define Package/fanctrl/conffiles
/etc/config/fan_ctrl
endef

define Package/fanctrl/install
    $(INSTALL_DIR) $(1)/etc/config
    $(INSTALL_CONF) ./files/etc/config/fan_ctrl $(1)/etc/config/
    
    $(INSTALL_DIR) $(1)/etc/init.d
    $(INSTALL_BIN) ./files/etc/init.d/fan_ctrl $(1)/etc/init.d/
    
    $(INSTALL_DIR) $(1)/usr/bin
    $(INSTALL_BIN) ./files/usr/bin/fan_ctrl.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,fanctrl))
