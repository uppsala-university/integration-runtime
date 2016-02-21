Summary:     	ServiceMix RPM
Name:           __PKG
Version:       	__VERSION
Release:        0
License:        none
Source0:       	%{name}-%{version}.zip
Source1:        %{name}.init
BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-build
Group:          System/Integration
Vendor:         Uppsala university

BuildRequires: zip

%define smx_home /opt/servicemix
%define smx_group smx
%define smx_user smx
# no repacking of jars
%define __jar_repack 0

%pre
getent group %{smx_group} >/dev/null || groupadd -r %{smx_group}
getent passwd %{smx_user} >/dev/null || /usr/sbin/useradd --comment "Servicemix User" --shell /bin/bash -M -r -g %{smx_group} --home %{smx_home} %{smx_user}

%description
This package is an installation package of Apache ServiceMix. Files will be installed under /opt/servicemix/%{name}-%{version} and data will be stored under /var/lib/servicemix. Other than that, it's a vanilla install from tarball.

%prep
%setup -q -n %{name}-%{version}

%build

%install
install -d $RPM_BUILD_ROOT/opt/servicemix/%{name}-%{version}
cp -R * $RPM_BUILD_ROOT/opt/servicemix/%{name}-%{version}
install -d $RPM_BUILD_ROOT/var/lib/servicemix
install -d $RPM_BUILD_ROOT/opt/servicemix/%{name}-%{version}/log
install -d -m 755 %{buildroot}/%{_initrddir}

# Drop init script
install -d -m 755 %{buildroot}/%{_initrddir}
install    -m 755 %_sourcedir/%{name}.init %{buildroot}/%{_initrddir}/%{name}

%post
if [ ! -d /var/lib/servicemix ]
then
	install -d -m 755 /var/lib/servicemix
fi
chown %{smx_user}:%{smx_group} /var/lib/servicemix

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf %{_tmppath}/%{name}
rm -rf %{_topdir}/BUILD/%{name}-%{version}

# list files owned by the package here
%files
%defattr(-,%{smx_user},%{smx_group})
%{smx_home}/%{name}-%{version}
%{_initrddir}/%{name}

%preun
/sbin/service/%{name} stop


%changelog
* Tue Feb 11 2014  John Källström
- 1.0 r1 First release
