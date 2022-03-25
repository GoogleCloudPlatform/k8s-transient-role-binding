# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package mocktime

vstime := time.now_ns() - (10 * 1e09)

vsrfc3339 := concat("T", [
	sprintf("%04d-%02d-%02d", time.date(vstime)),
	sprintf("%02d:%02d:%02dZ", time.clock(vstime)),
])

vetime := vstime + (360 * 1e09)

verfc3339 := concat("T", [
	sprintf("%04d-%02d-%02d", time.date(vetime)),
	sprintf("%02d:%02d:%02dZ", time.clock(vetime)),
])

spec := object.union(input, {
	"validUntil": verfc3339,
	"validFrom": vsrfc3339,
})
