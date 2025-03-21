import ballerina/http;
import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.parser;

isolated ExplanationOfBenefit[] eobs = [];
isolated int createEOBNextId = 9000;

public isolated function create(json payload) returns r4:FHIRError|ExplanationOfBenefit {
    ExplanationOfBenefit|error eob = parser:parse(payload).ensureType();
    if eob is error {
        return r4:createFHIRError(eob.message(), r4:ERROR, r4:INVALID, httpStatusCode = http:STATUS_BAD_REQUEST);
    } else {
        lock {
            createEOBNextId += 1;
            eob.id = (createEOBNextId).toBalString();
        }
        lock {
            eobs.push(eob.clone());
        }
        return eob;
    }
}

public isolated function getById(string id) returns r4:FHIRError|ExplanationOfBenefit {
    lock {
        foreach var item in eobs {
            if item.id == id {
                return item.clone();
            }
        }
    }
    return r4:createFHIRError(string `Cannot find an EOB resource with id: ${id}`, r4:ERROR, r4:INVALID, httpStatusCode = http:STATUS_NOT_FOUND);
}

public isolated function search(map<string[]>? searchParameters = ()) returns r4:FHIRError|r4:Bundle {
    r4:Bundle bundle = {
        'type: "collection"
    };
    if (searchParameters is map<string[]>) {
        foreach var key in searchParameters.keys() {
            match key {
                "_id" => {
                    ExplanationOfBenefit byId = check getById(searchParameters.get(key)[0]);
                    bundle.entry = [
                        {
                            'resource: byId
                        }
                    ];
                    return bundle;
                }
                _ => {
                    return r4:createFHIRError(string `Not supported search parameter: ${key}`, r4:ERROR, r4:INVALID, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
                }
            }
        }
    }
    lock {
        r4:BundleEntry[] bundleEntries = [];
        foreach var item in eobs {
            r4:BundleEntry bundleEntry = {
                'resource: item
            };
            bundleEntries.push(bundleEntry);
        }
        r4:Bundle cloneBundle = bundle.clone();
        cloneBundle.entry = bundleEntries;
        return cloneBundle.clone();
    }
}

function init() returns error? {
    lock {
        json eocJson = {
            "resourceType": "ExplanationOfBenefit",
            "id": "EOBOutpatient1",
            "meta": {
                "lastUpdated": "2019-12-12T09:14:11+00:00",
                "profile": ["http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit-Outpatient-Institutional"]
            },
            "language": "en-US",
            "text": {
                "status": "generated",
                "div": string `<div xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US"><p class="res-header-id"><b>Generated Narrative: ExplanationOfBenefit EOBOutpatient1</b></p><a name="EOBOutpatient1"> </a><a name="hcEOBOutpatient1"> </a><a name="EOBOutpatient1-en-US"> </a><div style="display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%"><p style="margin-bottom: 0px">Last updated: 2019-12-12 09:14:11+0000; Language: en-US</p><p style="margin-bottom: 0px">Profile: <a href="StructureDefinition-C4BB-ExplanationOfBenefit-Outpatient-Institutional.html">C4BB ExplanationOfBenefit Outpatient Institutionalversion: null2.1.0)</a></p></div><p><b>identifier</b>: Unique Claim ID/AW123412341234123412341234123412</p><p><b>status</b>: Active</p><p><b>type</b>: <span title="Codes:{http://terminology.hl7.org/CodeSystem/claim-type institutional}">Institutional</span></p><p><b>subType</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBInstitutionalClaimSubType outpatient}">Outpatient</span></p><p><b>use</b>: Claim</p><p><b>patient</b>: <a href="Patient-Patient2.html">Member 01 Test  Male, DoB: 1943-01-01 ( An identifier for the insured of an insurance policy (this insured always has a subscriber), usually assigned by the insurance carrier.:\u00a088800933501)</a></p><p><b>billablePeriod</b>: 2019-01-01 --&gt; 2019-10-31</p><p><b>created</b>: 2019-11-02 00:00:00+0000</p><p><b>insurer</b>: <a href="Organization-Payer1.html">Organization Payer 1</a></p><p><b>provider</b>: <a href="Organization-ProviderOrganization1.html">Orange Medical Group</a></p><p><b>outcome</b>: Partial Processing</p><h3>CareTeams</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Sequence</b></td><td><b>Provider</b></td><td><b>Role</b></td><td><b>Qualification</b></td></tr><tr><td style="display: none">*</td><td>1</td><td><a href="Organization-ProviderOrganization1.html">Organization Orange Medical Group</a></td><td><span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBClaimCareTeamRole rendering}">Rendering provider</span></td><td><span title="Codes:{http://nucc.org/provider-taxonomy 364SX0200X}">Oncology Clinical Nurse Specialist</span></td></tr></table><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 2</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType clmrecvddate}">Claim Received Date</span></p><p><b>timing</b>: 2019-11-30</p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 3</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType typeofbill}">Type of Bill</span></p><p><b>code</b>: <span title="Codes:{https://www.nubc.org/CodeSystem/TypeOfBill Dummy}">Dummy</span></p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 4</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType pointoforigin}">Point Of Origin</span></p><p><b>code</b>: <span title="Codes:{https://www.nubc.org/CodeSystem/PointOfOrigin Dummy}">Dummy</span></p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 5</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType admtype}">Admission Type</span></p><p><b>code</b>: <span title="Codes:{https://www.nubc.org/CodeSystem/PriorityTypeOfAdmitOrVisit Dummy}">Dummy</span></p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 6</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType discharge-status}">Discharge Status</span></p><p><b>code</b>: <span title="Codes:{https://www.nubc.org/CodeSystem/PatDischargeStatus Dummy}">Dummy</span></p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 7</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType medicalrecordnumber}">Medical Record Number</span></p><p><b>value</b>: 1234-234-1243-12345678901m</p></blockquote><blockquote><p><b>supportingInfo</b></p><p><b>sequence</b>: 8</p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType patientaccountnumber}">Patient Account Number</span></p><p><b>value</b>: 1234-234-1243-12345678901a</p></blockquote><h3>Diagnoses</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Sequence</b></td><td><b>Diagnosis[x]</b></td><td><b>Type</b></td></tr><tr><td style="display: none">*</td><td>1</td><td><span title="Codes:{http://hl7.org/fhir/sid/icd-10-cm S06.0X1A}">Concussion w LOC of 30 minutes or less, init</span></td><td><span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBClaimDiagnosisType patientreasonforvisit}">Patient Reason for Visit</span></td></tr></table><h3>Insurances</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Focal</b></td><td><b>Coverage</b></td></tr><tr><td style="display: none">*</td><td>true</td><td><a href="Coverage-Coverage3.html">Coverage: identifier = Member Number; status = active; type = health insurance plan policy; subscriberId = 12345678901; dependent = 01; relationship = Self; period = 2019-01-01 --&gt; 2019-10-31; network = XYZ123-UPMC CONSUMER ADVA</a></td></tr></table><h3>Items</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Sequence</b></td><td><b>Revenue</b></td><td><b>ProductOrService</b></td><td><b>Serviced[x]</b></td></tr><tr><td style="display: none">*</td><td>1</td><td><span title="Codes:{https://www.nubc.org/CodeSystem/RevenueCodes Dummy}">Dummy</span></td><td><span title="Codes:{http://terminology.hl7.org/CodeSystem/data-absent-reason not-applicable}">Not Applicable</span></td><td>2019-11-02</td></tr></table><blockquote><p><b>adjudication</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudicationDiscriminator benefitpaymentstatus}">Benefit Payment Status</span></p><p><b>reason</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBPayerAdjudicationStatus innetwork}">In Network</span></p></blockquote><blockquote><p><b>adjudication</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudicationDiscriminator billingnetworkstatus}">Billing Network Status</span></p><p><b>reason</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBPayerAdjudicationStatus innetwork}">In Network</span></p></blockquote><blockquote><p><b>adjudication</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication paidtoprovider}">Payment Amount</span></p><h3>Amounts</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Value</b></td><td><b>Currency</b></td></tr><tr><td style="display: none">*</td><td>620</td><td>United States dollar</td></tr></table></blockquote><blockquote><p><b>adjudication</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication paidbypatient}">Patient Pay Amount</span></p><h3>Amounts</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Value</b></td></tr><tr><td style="display: none">*</td><td>0</td></tr></table></blockquote><blockquote><p><b>total</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication paidtoprovider}">Payment Amount</span></p><h3>Amounts</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Value</b></td><td><b>Currency</b></td></tr><tr><td style="display: none">*</td><td>620</td><td>United States dollar</td></tr></table></blockquote><blockquote><p><b>total</b></p><p><b>category</b>: <span title="Codes:{http://terminology.hl7.org/CodeSystem/adjudication submitted}">Submitted Amount</span></p><h3>Amounts</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Value</b></td><td><b>Currency</b></td></tr><tr><td style="display: none">*</td><td>2650</td><td>United States dollar</td></tr></table></blockquote><blockquote><p><b>total</b></p><p><b>category</b>: <span title="Codes:{http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication paidbypatient}">Patient Pay Amount</span></p><h3>Amounts</h3><table class="grid"><tr><td style="display: none">-</td><td><b>Value</b></td><td><b>Currency</b></td></tr><tr><td style="display: none">*</td><td>0</td><td>United States dollar</td></tr></table></blockquote></div>`
            },
            "identifier": [
                {
                    "type": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType",
                                "code": "uc"
                            }
                        ]
                    },
                    "system": "https://www.xxxplan.com/fhir/EOBIdentifier",
                    "value": "AW123412341234123412341234123412"
                }
            ],
            "status": "active",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/claim-type",
                        "code": "institutional"
                    }
                ],
                "text": "Institutional"
            },
            "subType": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBInstitutionalClaimSubType",
                        "code": "outpatient"
                    }
                ],
                "text": "Outpatient"
            },
            "use": "claim",
            "patient": {
                "reference": "Patient/Patient2"
            },
            "billablePeriod": {
                "start": "2019-01-01",
                "end": "2019-10-31"
            },
            "created": "2019-11-02T00:00:00+00:00",
            "insurer": {
                "reference": "Organization/Payer1",
                "display": "Organization Payer 1"
            },
            "provider": {
                "reference": "Organization/ProviderOrganization1",
                "display": "Orange Medical Group"
            },
            "outcome": "partial",
            "careTeam": [
                {
                    "sequence": 1,
                    "provider": {
                        "reference": "Organization/ProviderOrganization1"
                    },
                    "role": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBClaimCareTeamRole",
                                "code": "rendering",
                                "display": "Rendering provider"
                            }
                        ]
                    },
                    "qualification": {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "364SX0200X",
                                "display": "Oncology Clinical Nurse Specialist"
                            }
                        ]
                    }
                }
            ],
            "supportingInfo": [
                {
                    "sequence": 2,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "clmrecvddate"
                            }
                        ]
                    },
                    "timingDate": "2019-11-30"
                },
                {
                    "sequence": 3,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "typeofbill"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "https://www.nubc.org/CodeSystem/TypeOfBill",
                                "code": "Dummy"
                            }
                        ]
                    }
                },
                {
                    "sequence": 4,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "pointoforigin"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "https://www.nubc.org/CodeSystem/PointOfOrigin",
                                "code": "Dummy"
                            }
                        ]
                    }
                },
                {
                    "sequence": 5,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "admtype"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "https://www.nubc.org/CodeSystem/PriorityTypeOfAdmitOrVisit",
                                "code": "Dummy"
                            }
                        ]
                    }
                },
                {
                    "sequence": 6,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "discharge-status"
                            }
                        ]
                    },
                    "code": {
                        "coding": [
                            {
                                "system": "https://www.nubc.org/CodeSystem/PatDischargeStatus",
                                "code": "Dummy"
                            }
                        ]
                    }
                },
                {
                    "sequence": 7,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "medicalrecordnumber"
                            }
                        ]
                    },
                    "valueString": "1234-234-1243-12345678901m"
                },
                {
                    "sequence": 8,
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBSupportingInfoType",
                                "code": "patientaccountnumber"
                            }
                        ]
                    },
                    "valueString": "1234-234-1243-12345678901a"
                }
            ],
            "diagnosis": [
                {
                    "sequence": 1,
                    "diagnosisCodeableConcept": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/sid/icd-10-cm",
                                "code": "S06.0X1A"
                            }
                        ]
                    },
                    "type": [
                        {
                            "coding": [
                                {
                                    "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBClaimDiagnosisType",
                                    "code": "patientreasonforvisit"
                                }
                            ]
                        }
                    ]
                }
            ],
            "insurance": [
                {
                    "focal": true,
                    "coverage": {
                        "reference": "Coverage/Coverage3"
                    }
                }
            ],
            "item": [
                {
                    "sequence": 1,
                    "revenue": {
                        "coding": [
                            {
                                "system": "https://www.nubc.org/CodeSystem/RevenueCodes",
                                "code": "Dummy"
                            }
                        ]
                    },
                    "productOrService": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/data-absent-reason",
                                "code": "not-applicable",
                                "display": "Not Applicable"
                            }
                        ]
                    },
                    "servicedDate": "2019-11-02"
                }
            ],
            "adjudication": [
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudicationDiscriminator",
                                "code": "benefitpaymentstatus"
                            }
                        ]
                    },
                    "reason": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBPayerAdjudicationStatus",
                                "code": "innetwork"
                            }
                        ]
                    }
                },
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudicationDiscriminator",
                                "code": "billingnetworkstatus"
                            }
                        ]
                    },
                    "reason": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBPayerAdjudicationStatus",
                                "code": "innetwork"
                            }
                        ]
                    }
                },
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication",
                                "code": "paidtoprovider"
                            }
                        ],
                        "text": "Payment Amount"
                    },
                    "amount": {
                        "value": 620,
                        "currency": "USD"
                    }
                },
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication",
                                "code": "paidbypatient"
                            }
                        ],
                        "text": "Patient Pay Amount"
                    },
                    "amount": {
                        "value": 0
                    }
                }
            ],
            "total": [
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication",
                                "code": "paidtoprovider"
                            }
                        ],
                        "text": "Payment Amount"
                    },
                    "amount": {
                        "value": 620,
                        "currency": "USD"
                    }
                },
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/adjudication",
                                "code": "submitted"
                            }
                        ],
                        "text": "Submitted Amount"
                    },
                    "amount": {
                        "value": 2650,
                        "currency": "USD"
                    }
                },
                {
                    "category": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication",
                                "code": "paidbypatient"
                            }
                        ],
                        "text": "Patient Pay Amount"
                    },
                    "amount": {
                        "value": 0,
                        "currency": "USD"
                    }
                }
            ]
        };

        ExplanationOfBenefit eob = check parser:parse(eocJson).ensureType();
        eobs.push(eob.clone());
    }
}
