Summary:     	Karaf RPM
Name:           apache-karaf
Version:       	4.0.4
Release:        0
License:        none
Source0:       	%{name}-%{version}.zip
#BuildArch:      noarch
BuildRoot:      %{_tmppath}/%{name}-build
Group:          System/Integration
Vendor:         Uppsala university

BuildRequires: zip

%define karaf_home /opt
%define karaf_group karaf
%define karaf_user karaf
# no repacking of jars
%define __jar_repack 0
%define debug_package %{nil}

%pre
getent group %{karaf_group} >/dev/null || groupadd -r %{karaf_group}
getent passwd %{karaf_user} >/dev/null || /usr/sbin/useradd --comment "Karaf User" --shell /bin/bash -M -r -g %{karaf_group} --home %{karaf_home} %{karaf_user}

%description
This package is an installation package of Apache Karaf. Files will be installed under /opt/%{name}-%{version}. Other than that, it's a vanilla install from tarball.

%prep
%setup -q -n %{name}-%{version}

%build

%install
install -d %{buildroot}%{karaf_home}/%{name}-%{version}
cp -R * %{buildroot}%{karaf_home}/%{name}-%{version}
install -d %{buildroot}%{karaf_home}/%{name}-%{version}/log
install -d -m 755 %{buildroot}%{_initrddir}

# Install service wrapper
#install -d -m 755 %{buildroot}%{karaf_home}/%{name}-%{version}/lib/wrapper
#chown %{karaf_user}:%{karaf_group} %{buildroot}%{karaf_home}/%{name}-%{version}/lib/wrapper
#install -m 755 %_sourcedir/karaf-wrapper %{buildroot}%{karaf_home}/%{name}-%{version}/bin
#install -m 755 %_sourcedir/karaf-service %{buildroot}%{karaf_home}/%{name}-%{version}/bin
#install -m 755 %_sourcedir/karaf.service %{buildroot}%{karaf_home}/%{name}-%{version}/bin
#install -m 755 %_sourcedir/karaf-wrapper.conf %{buildroot}%{karaf_home}/%{name}-%{version}/etc
#install -m 755 %_sourcedir/libwrapper.so %{buildroot}%{karaf_home}/%{name}-%{version}/lib/wrapper
#install -m 755 %_sourcedir/karaf-wrapper.jar %{buildroot}%{karaf_home}/%{name}-%{version}/lib/wrapper
#install -m 755 %_sourcedir/karaf-wrapper-main.jar %{buildroot}%{karaf_home}/%{name}-%{version}/lib/wrapper

%post
# Point karaf to installed version
if [ -h %{karaf_home}/%{name} ]
then
	rm -f %{karaf_home}/%{name}
fi
%{__ln_s} -f %{karaf_home}/%{name}-%{version} %{karaf_home}/%{name}

# Link init-script to init rd dir
if [ ! -h {_initrddir}/karaf-service ]
then
	%{__ln_s} -f %{karaf_home}/%{name}/bin/karaf-service %{_initrddir}/%{name}
fi


%clean
rm -rf $RPM_BUILD_ROOT
rm -rf %{_tmppath}/%{name}
rm -rf %{_topdir}/BUILD/%{name}-%{version}

# list files owned by the package here
%files
%defattr(-,%{karaf_user},%{karaf_group})
%{karaf_home}/%{name}-%{version}

%preun
%{_initrddir}/%{name} stop


%changelog
* Wed Jan 27 2016 Markus Jardemalm
- 1.0 First release
