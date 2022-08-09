%define buildid @BUILDID@


Name:           koji-test-rpm
Version:        1.0
Release:        1%{buildid}
Summary:	Test package summary

Group:          Libraries
License:        MIT
Source:         %{name}-%{version}.tar.gz

BuildArch:      noarch

Requires: bash

%description
Description

%prep
%setup -q

# %build

%install
mkdir -p ${RPM_BUILD_ROOT}%{_bindir}
install -m 755 example-shell-script.sh ${RPM_BUILD_ROOT}%{_bindir}

%clean
rm -rf %buildroot

%files
%defattr(-,root,root)
%attr(755,root,root) %{_bindir}/example-shell-script.sh
