Summary:     	ActiveMQ RPM
Name:           __PKG
Version:       	__VERSION
Release:        0
License:        none
Source0:       	%{name}-%{version}-bin.tar.gz
BuildRoot:      %{_tmppath}/%{name}-build
Group:          System/Integration
Vendor:         Uppsala university

BuildRequires: tar

%define activemq_home /opt
%define activemq_group activemq
%define activemq_user activemq
# no repacking of jars
%define __jar_repack 0
%define debug_package %{nil}

%pre
getent group %{activemq_group} >/dev/null || groupadd -r %{activemq_group}
getent passwd %{activemq_user} >/dev/null || /usr/sbin/useradd --comment "ActiveMQ User" --shell /bin/bash -M -r -g %{activemq_group} --home %{activemq_home} %{activemq_user}

%description
This package is an installation package of Apache ActiveMQ. Files will be installed under /opt/%{name}-%{version}. Other than that, it's a vanilla install from tarball.

%prep
%setup -q -n %{name}-%{version}

%build

%install
install -d %{buildroot}%{activemq_home}/%{name}-%{version}
cp -R * %{buildroot}%{activemq_home}/%{name}-%{version}
install -d %{buildroot}%{activemq_home}/%{name}-%{version}/log
install -d -m 755 %{buildroot}%{_initrddir}
chmod ug+x %{buildroot}%{activemq_home}/%{name}-%{version}/bin/activemq

%post
# Point apache-activemq to installed version
if [ -h %{activemq_home}/%{name} ]
then
	rm -f %{activemq_home}/%{name}
fi
%{__ln_s} -f %{activemq_home}/%{name}-%{version} %{activemq_home}/%{name}

# Link init-script to init rd dir
if [ ! -h {_initrddir}/apache-activemq ]
then
	%{__ln_s} -f %{activemq_home}/%{name}/bin/activemq %{_initrddir}/%{name}
fi


%clean
rm -rf $RPM_BUILD_ROOT
rm -rf %{_tmppath}/%{name}
rm -rf %{_topdir}/BUILD/%{name}-%{version}

# list files owned by the package here
%files
%defattr(-,%{activemq_user},%{activemq_group})
%{activemq_home}/%{name}-%{version}

%preun
%{_initrddir}/%{name} stop


%changelog
* Wed Jan 28 2016 Markus Jardemalm
- 1.0 First release
