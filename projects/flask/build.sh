#!/bin/bash -eu
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Build flask
cd $SRC/flask
python3 -m pip install importlib_metadata
pip3 install -r ./requirements/tests-pallets-min.in
pip3 install .

# Build flask-cors
cd $SRC/flask-cors
pip3 install requests
pip3 install .

# Build flask-cors fuzzers
cd $SRC/flask-cors
compile_python_fuzzer $SRC/cors_fuzz_flask.py

# Build flask fuzzers
# Build fuzzers in $OUT.
for fuzzer in $(find $SRC -name 'fuzz_*.py'); do
  compile_python_fuzzer $fuzzer
done

# Copy dictionaries out
cp $SRC/fuzzing/dictionaries/http.dict $OUT/fuzz_werkzeug_http.dict
