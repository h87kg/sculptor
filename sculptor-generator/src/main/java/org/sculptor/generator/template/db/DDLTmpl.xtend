/*
 * Copyright 2007 The Fornax Project Team, including the original 
 * author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.sculptor.generator.template.db

import sculptormetamodel.*

import static extension org.sculptor.generator.ext.DbHelper.*
import static extension org.sculptor.generator.util.DbHelperBase.*
import static extension org.sculptor.generator.ext.Helper.*
import static extension org.sculptor.generator.util.HelperBase.*
import static extension org.sculptor.generator.ext.Properties.*
import static extension org.sculptor.generator.util.PropertiesBase.*

class DDLTmpl {

def static String ddl(Application it) {
	'''
		�IF dbProduct() == "mysql"�
			�MysqlDDL::ddl(it) �
		�ENDIF�
		�IF dbProduct() == "oracle"�
			�OracleDDL::ddl(it) �
		�ENDIF�
		�IF dbProduct() == "postgresql"�
			�OracleDDL::ddl(it) �
		�ENDIF�
		�IF dbProduct() == "custom"�
			�CustomDDL::ddl(it) �
		�ENDIF�
	'''
}

}
