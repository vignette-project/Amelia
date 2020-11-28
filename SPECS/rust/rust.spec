Summary:        Rust Programming Language
Name:           rust
Version:        1.39.0
Release:        7%{?dist}
License:        ASL 2.0 and MIT
URL:            https://www.rust-lang.org/
Group:          Applications/System
Vendor:         Microsoft Corporation
Distribution: Amelia
Source0:        https://static.rust-lang.org/dist/rustc-%{version}-src.tar.xz
Source1:        %{name}-%{version}-cargo.tar.gz
Source2:        https://static.rust-lang.org/dist/2019-09-26/cargo-0.39.0-x86_64-unknown-linux-gnu.tar.gz
Source3:        https://static.rust-lang.org/dist/2019-09-26/rustc-1.38.0-x86_64-unknown-linux-gnu.tar.gz
Source4:        https://static.rust-lang.org/dist/2019-09-26/rust-std-1.38.0-x86_64-unknown-linux-gnu.tar.gz
Source5:        https://static.rust-lang.org/dist/2019-09-26/cargo-0.39.0-aarch64-unknown-linux-gnu.tar.gz
Source6:        https://static.rust-lang.org/dist/2019-09-26/rustc-1.38.0-aarch64-unknown-linux-gnu.tar.gz
Source7:        https://static.rust-lang.org/dist/2019-09-26/rust-std-1.38.0-aarch64-unknown-linux-gnu.tar.gz

Patch0:         robust-build.patch

BuildRequires:  git
BuildRequires:  cmake
BuildRequires:  glibc
BuildRequires:  binutils
BuildRequires:  python2
BuildRequires:  curl-devel

%description
Rust Programming Language

%prep
# Setup .cargo directory
mkdir -p $HOME
pushd $HOME
tar xf %{SOURCE1} --no-same-owner
popd
%setup -q -n rustc-%{version}-src

%patch0 -p1

# Setup build/cache directory
%define BUILD_CACHE_DIR build/cache/2019-09-26/
mkdir -pv %{BUILD_CACHE_DIR}
%ifarch x86_64
mv %{SOURCE2} %{BUILD_CACHE_DIR}
mv %{SOURCE3} %{BUILD_CACHE_DIR}
mv %{SOURCE4} %{BUILD_CACHE_DIR}
%endif
%ifarch aarch64
mv %{SOURCE5} %{BUILD_CACHE_DIR}
mv %{SOURCE6} %{BUILD_CACHE_DIR}
mv %{SOURCE7} %{BUILD_CACHE_DIR}
%endif

%build
# Disable symbol generation
export CFLAGS="`echo " %{build_cflags} " | sed 's/ -g//'`"
export CXXFLAGS="`echo " %{build_cxxflags} " | sed 's/ -g//'`"

sh ./configure --prefix=%{_prefix} --enable-extended --tools="cargo"
# Exporting SUDO_USER=root bypasses a check in the python bootstrap that
# makes rust refuse to pull sources from the internet
export USER=root
export SUDO_USER=root
make %{?_smp_mflags}

%check
make check

%install
export USER=root
export SUDO_USER=root
make DESTDIR=%{buildroot} install
rm %{buildroot}%{_docdir}/%{name}/html/.lock
rm %{buildroot}%{_docdir}/%{name}/*.old

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%license LICENSE-MIT
%doc CONTRIBUTING.md README.md RELEASES.md
%{_bindir}/rustc
%{_bindir}/rustdoc
%{_bindir}/rust-lldb
%{_mandir}/man1/*
%{_libdir}/lib*.so
%{_libdir}/rustlib/*
%{_bindir}/rust-gdb
%{_bindir}/rust-gdbgui
%doc %{_docdir}/%{name}/html/*
%{_docdir}/%{name}/html/.stamp
%doc %{_docdir}/%{name}/README.md
%doc %{_docdir}/%{name}/COPYRIGHT
%doc %{_docdir}/%{name}/LICENSE-APACHE
%doc %{_docdir}/%{name}/LICENSE-MIT
%doc src/tools/rustfmt/{README,CHANGELOG,Configurations}.md
%doc src/tools/clippy/{README.md,CHANGELOG.md}
%{_bindir}/cargo
%{_datadir}/zsh/*
%doc %{_docdir}/%{name}/LICENSE-THIRD-PARTY
%{_sysconfdir}/bash_completion.d/cargo

%changelog
*   Wed Aug 12 2020 Mateusz Malisz <mamalisz@microsoft.com> 1.39.0-7
-   Add patch for the build to not fail on file not found error.
*   Fri Jun 12 2020 Henry Beberman <henry.beberman@microsoft.com> 1.39.0-6
-   Temporarily disable generation of debug symbols.
*   Thu May 28 2020 Chris Co <chrco@microsoft.com> - 1.39.0-5
-   Update source checkout and prep steps
*   Sat May 09 00:20:39 PST 2020 Nick Samson <nisamson@microsoft.com> - 1.39.0-4
-   Added %%license line automatically
*   Mon May 4 2020 Nicolas Guibourge <nicolasg@microsoft.com> 1.39.0-3
-   Fix build issue when building from Docker
*   Tue Apr 21 2020 Andrew Phelps <anphel@microsoft.com> 1.39.0-2
-   Support building offline.
*   Thu Mar 19 2020 Henry Beberman <henry.beberman@microsoft.com> 1.39.0-1
-   Update to 1.39.0. Fix URL. Fix Source0 URL. License verified.
*   Thu Feb 27 2020 Henry Beberman <hebeberm@microsoft.com> 1.34.2-3
-   Set SUDO_USER and USER to allow rust to hydrate as root
*   Wed Sep 25 2019 Saravanan Somasundaram <sarsoma@microsoft.com> 1.34.2-2
-   Initial CBL-Mariner import from Photon (license: Apache2)
*   Wed May 15 2019 Ankit Jain <ankitja@vmware.com> 1.34.2-1
-   Initial build. First version
