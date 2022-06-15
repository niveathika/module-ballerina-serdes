// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.

// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

type Employee record {
    string name;
    byte age;
    int weight;
    float height;
    boolean isMarried;
    decimal salary;
};

type RecordArray Employee[];

type RecordWithArrays record {
    string[] stringArray;
    int[] intArray;
    float[] floatArray;
    boolean[] boolArray;
    byte[] byteArray;
};

type Contact record {
    string mobile;
    string home;
};

// Nested record
type Person record {
    string name;
    int age;
    byte[] img;
    float random;
    Contact contact;
};

// Record with optional field
type Member record {
    string name;
    decimal? salary;
    Contact contact?;
};

type Street record {
    string street1;
    string street2;
};

type Address record {
    Street street;
    string country;
};

// Complex record
type Account record {
    string name;
    int age;
    byte[] img;
    Contact[] contacts;
    Address? address;
    int rating?;
};


type RecordWithUnionFields record {
    string name;
    int|string[]|UnionMember|() membership;
};

@test:Config {}
public isolated function testRecordWithPrimitives() returns error? {
    Employee jhon = {
        name: "Jhon",
        age: 30,
        weight: 58,
        height: 6.2,
        isMarried: false,
        salary: 120000.99d
    };

    Proto3Schema ser = check new (Employee);
    byte[] encoded = check ser.serialize(jhon);

    Proto3Schema des = check new (Employee);
    Employee decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, jhon);
}

@test:Config {}
public isolated function testArrayOfRecords() returns error? {
    RecordArray data = [
        {
            name: "Jhon",
            age: 30,
            weight: 58,
            height: 6.2,
            isMarried: false,
            salary: 120000.99d
        },
        {
            name: "Victor",
            age: 24,
            weight: 60,
            height: 5.9,
            isMarried: true,
            salary: 30e3
        }
    ];

    Proto3Schema ser = check new (RecordArray);
    byte[] encoded = check ser.serialize(data);

    Proto3Schema des = check new (RecordArray);
    RecordArray decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, data);
}

@test:Config {}
public isolated function testRecordWithArrays() returns error? {
    RecordWithArrays arrayRecord = {
        stringArray: ["Jane", "Doe"],
        intArray: [1, 2, 3],
        floatArray: [0.123, 4.968, 3.256],
        boolArray: [true, false, true, false],
        byteArray: base16 `aeeecdefabcd12345567888822`
    };

    Proto3Schema ser = check new (RecordWithArrays);
    byte[] encoded = check ser.serialize(arrayRecord);

    Proto3Schema des = check new (RecordWithArrays);
    RecordWithArrays decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, arrayRecord);
}

@test:Config {}
public isolated function testNestedRecord() returns error? {
    byte[] img = base16 `aeeecdefabcd12345567888822`;
    Contact phone = {mobile: "+94111111111", home: "+94777777777"};
    Person president = {name: "Joe", age: 70, img: img, random: 1.666, contact: phone};

    Proto3Schema ser = check new (Person);
    byte[] encoded = check ser.serialize(president);

    Proto3Schema des = check new (Person);
    Person decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, president);
}

@test:Config {}
public isolated function testRecordWithOptinalField() returns error? {
    Member member = {name: "Jack", salary: ()};

    Proto3Schema ser = check new (Member);
    byte[] encoded = check ser.serialize(member);

    Proto3Schema des = check new (Member);
    Member decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, member);
}

@test:Config {}
public isolated function testComplexRecord() returns error? {
    byte[] byteArray = base16 `aeeecdefabcd12345567888822`;
    Contact phone1 = {mobile: "+123456", home: "789"};
    Contact phone2 = {mobile: "+456789", home: "123"};
    Street street = {street1: "random lane", street2: "random street"};
    Address address = {street: street, country: "Sri Lanka"};
    Contact[] nums = [phone1, phone2];
    Account john = {name: "John Doe", age: 21, img: byteArray, contacts: nums, address: address};

    Proto3Schema ser = check new (Account);
    byte[] encoded = check ser.serialize(john);

    Proto3Schema des = check new (Account);
    Account decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, john);
}

@test:Config {}
public isolated function testRecordWithUnionFields() returns error? {
    RecordWithUnionFields rec = {name: "Jane", membership: ()};

    Proto3Schema ser = check new (RecordWithUnionFields);
    byte[] encoded = check ser.serialize(rec);

    Proto3Schema des = check new (RecordWithUnionFields);
    RecordWithUnionFields decoded = check des.deserialize(encoded);
    test:assertEquals(decoded, rec);
}
