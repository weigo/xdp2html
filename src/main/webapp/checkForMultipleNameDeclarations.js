/*
 * Copyright 2005, 2007 the original author or authors. Licensed under the
 * Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law
 * or agreed to in writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
 
elementInfo = {};

function checkForMultipleNameDeclarations() {
	getTextFieldInfo();
	getTextAreaInfo();
}

function getTextFieldInfo() {
	var elements = document.getElementsByTagName("input");
	var i, elem;
	
	for (i = 0; i < elements.length; i+= 1) {
		elem = elements[i];

		if (elem.type == "text") {
			updateElementInfo(elem);
		}
	}
}

function getTextAreaInfo() {
	var elements = document.getElementsByTagName("textarea");
	
	for (var i = 0; i < elements.length; i += 1) {
		updateElementInfo(elements[i]);
	}
}

function updateElementInfo(elem) {
	var	field = elementInfo[elem.name];
	if (field === undefined) {
		field = new Array();
		field[0] = elem;
	}
	else {
		field[0].style.border = "solid red 1px";
		field[0].value = 'original: ' + elem.name;
		field[field.length + 1] = elem;
		elem.style.border = "solid red 1px";
		elem.value = 'duplicate element: ' + elem.name;
	}
	
	elementInfo[elem.name] = field;
}