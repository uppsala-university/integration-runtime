Summary:	Tomcat RPM
Name:		__PKG
Version:	__VERSION
Release:	0
License:	none
Source0:	%{name}-%{version}.zip
Source1:	%{name}.init
BuildRoot:	%{_tmppath}/%{name}-build
Group:		System/Integration
Vendor:		Uppsala university

BuildRequires: zip

%define tomcat_home /opt
%define tomcat_group tomcat
%define tomcat_user tomcat
# no repacking of jars
%define __jar_repack 0
%define debug_package %{nil}

%pre
getent group %{tomcat_group} >/dev/null || groupadd -r %{tomcat_group}
getent passwd %{tomcat_user} >/dev/null || /usr/sbin/useradd --comment "Tomcat User" --shell /bin/bash -M -r -g %{tomcat_group} --home %{tomcat_home} %{tomcat_user}

%description
This package is an installation package of Apache Tomcat. Files will be installed under /opt/%{name}-%{version}. Other than that, it's a vanilla install from tarball.

%prep
%setup -q -n %{name}-%{version}

%build

%install
install -d %{buildroot}%{tomcat_home}/%{name}-%{version}
cp -R * %{buildroot}%{tomcat_home}/%{name}-%{version}
install -d %{buildroot}%{tomcat_home}/%{name}-%{version}/log
install -d -m 755 %{buildroot}%{_initrddir}

# Drop init script
install -d -m 755 %{buildroot}/%{_initrddir}
install -m 755 %_sourcedir/%{name}.init %{buildroot}/%{_initrddir}/%{name}

%post
# Point Tomcat to installed version
if [ -h %{tomcat_home}/%{name} ]
then
	rm -f %{tomcat_home}/%{name}
fi
%{__ln_s} -f %{tomcat_home}/%{name}-%{version} %{tomcat_home}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf %{_tmppath}/%{name}
rm -rf %{_topdir}/BUILD/%{name}-%{version}

# list files owned by the package here
%files
%defattr(-,%{tomcat_user},%{tomcat_group})
%{tomcat_home}/%{name}-%{version}
%{_initrddir}/%{name}

%preun
%{_initrddir}/%{name} stop

%changelog
* Mon Feb 22 2016 Markus Jardemalm
- 1.0 First release
