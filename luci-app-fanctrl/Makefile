include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Interface for Fan Control
LUCI_DEPENDS:=+fanctrl +luci-lib-json +luci-compat
LUCI_PKGARCH:=all
PKG_MAINTAINER:=Your Name <your@email.com>
PKG_VERSION:=2.0

PO_DIR:=po/zh-cn
LUCI_I18N:=zh-cn

include ../../luci.mk

define Build/Compile
    $(foreach po,$(wildcard ${CURDIR}/po/zh-cn/*.po), \
        po2lmo $(po) $(PKG_BUILD_DIR)/po/zh-cn/$(notdir $(po:.po=.lmo));)
endef

define Package/luci-app-fanctrl/install
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci
    cp -pR ./files/usr/lib/lua/luci/* $(1)/usr/lib/lua/luci/
    
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
    $(INSTALL_DATA) $(PKG_BUILD_DIR)/po/zh-cn/*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,luci-app-fanctrl))
