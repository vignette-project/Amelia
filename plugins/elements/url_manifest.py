# Copyright (c) 2020 freedesktop-sdk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# This file is a modified derivative of the Collect Manifest plugin,
# released under the same license
#
# Authors:
#        Valentin David <valentin.david@gmail.com> (Collect Manifest)
#        Adam Jones <adam.jones@codethink.co.uk>   (Collect Manifest)
#        Douglas Winship <douglas.winship@codethink.co.uk> (Url Manifest)
"""Url Manifest Element

A buildstream plugin used to produce a manifest file
containing a list of source urls for a given dependency,
and all its subdependencies, down to the bottom of the tree.

The manifest contains information such as:
    - the alias used in the url (null if no alias is used)
    - the 'main' source url

The manifest file is exported as a json file to the path provided
under the "path" variable defined in the .bst file.

We'd also like to include the list of mirror urls (which may be empty).
Currently not possible to do that from a plugin, requires an external
script to add mirror info to the manifest after it's created.
"""

import json
import os
import re
from buildstream import Element, Scope

def get_source_locations(sources):
    """
    Returns a list of source URLs and refs, currently for
    git, tar, ostree, remote, zip and tar sources.
    Patch sources are not included in the ouput, since
    they don't have source URLs

    :sources A list or generator of BuildStream Sources
    """
    source_locations = []
    for source in sources:
        source_kind = source.get_kind()
        if source_kind == 'cargo':
            raw_cargo_url = source.url
            cargo_alias = raw_cargo_url.split(':', 1)[0]
            base_cargo_url = source.translate_url(source.url)
            for crate in source.ref:
                rest_of_url = '/{}/{}-{}.crate'.format(
                    crate['name'], crate['name'], crate['version']
                )
                source_locations.append({
                    'kind': 'cargo',
                    'alias': cargo_alias,
                    'raw_url': raw_cargo_url + rest_of_url,
                    'source_url': base_cargo_url + rest_of_url,
                })
        if source_kind in ['git', 'git_tag', 'ostree', 'tar', 'zip', 'remote', 'pypi']:
            #skip over sources that don't have source URLs, like patch sources
            if source_kind in ['tar', 'zip', 'remote', 'ostree', 'pypi']:
                source_url = source.url
            if source_kind in ['git', 'git_tag']:
                source_url = source.translate_url(
                    source.original_url,
                    alias_override=None,
                    primary=source.mirror.primary
                )

            raw_url = source.original_url
            if source_url == raw_url:
                # no alias detected, no translation done
                alias = None
            else:
                # the system must have recognised an alias, therefore...
                # ...everything before the first colon is the alias
                # This would be easier if source._get_alias() wasn't a protected part of the class
                alias = raw_url.split(':', 1)[0]


            source_dict = {
                'kind': source_kind,
                'alias' : alias,
                'raw_url' : raw_url,
                'source_url' : source_url,
            }
            if source_kind == 'ostree':
                source_dict['ref'] = source.ref
            if source_kind in ['git', 'git_tag']:
                source_dict['ref'] = source.mirror.ref
                m = re.match(r'(?P<tag>.*)-[0-9]+-g(?P<ref>.*)', source.mirror.ref)
                if m:
                    source_dict['tag'] = m.group('tag')
                else:
                    source_dict['tag'] = None
            source_locations.append(source_dict)

    return source_locations


class UrlManifestElement(Element):

    BST_FORMAT_VERSION = 1

    def configure(self, node):
        if 'path' in node:
            self.path = self.node_subst_member(node, 'path', None)
        else:
            self.path = None

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {
            'path': self.path,
            'version': self.BST_FORMAT_VERSION
        }
        return key

    def configure_sandbox(self, sandbox):
        pass

    def stage(self, sandbox):
        pass

    def assemble(self, sandbox):
        manifest = []
        visited_names_list = []

        for dep in self.dependencies(Scope.ALL, recurse=True):
            #de-duplicate list (some elements in bootstrap seem to get listed multiple times)
            if dep.name in visited_names_list:
                continue
            visited_names_list.append(dep.name)

            sources = get_source_locations(dep.sources())
            if sources:
                manifest.append({
                    'element': dep.name, 'sources': sources})

        if self.path:
            basedir = sandbox.get_directory()
            path = os.path.join(basedir, self.path.lstrip(os.path.sep))
            if os.path.isfile(path):
                if path[-1].isdigit():
                    version = int(path[-1]) + 1
                    new_path = list(path)
                    new_path[-1] = str(version)
                    path = ''.join(new_path)
                else:
                    path = path + '-1'
            os.makedirs(os.path.dirname(path), exist_ok=True)

            with open(path, 'w') as open_file:
                json.dump(manifest, open_file, indent=2)

        return os.path.sep

def setup():
    return UrlManifestElement
