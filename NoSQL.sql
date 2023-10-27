db.createCollection('Estate_Agent')
db.createCollection('Branch')
db.createCollection('Staff')
db.createCollection('Address')

db.Estate_Agent.insertMany([{_id: 'EA1', EAName: 'Rich and sons', Website: 'www.richandsons.co.uk'},
  {_id: 'EA2', EAName: 'Ziemann LLC', Website: 'www.ziemann.co.uk'},
  {_id: 'EA3', EAName: 'VonRueden LLC', Website: 'www.vonrueden.co.uk'},
  {_id: 'EA4', EAName: 'Toy LLC', Website: 'www.toy.co.uk'},
  {_id: 'EA5', EAName: 'Nolan Ltd', Website: 'www.Nolan.co.uk'}
  ])

db.Staff.insertMany([
  {_id: '1', FName: 'Joseph', LName: 'Burton', Gender: 'M', TelNo: '07702954363', Email: 'hand.edison@gmail.com', EA_ID:'EA1'},
  {_id: '2', FName: 'Mckayla', LName: 'Austin', Gender: 'F', TelNo: '07907260689', Email: 'Julian_Gray5187@famism.biz', EA_ID:'EA1'},
  {_id: '3', FName: 'Bailey', LName: 'King', Gender: 'F', TelNo: '07082654598', Email: 'kulas.hobart@kling.org', EA_ID:'EA1'},
  {_id: '4', FName: 'Matthew', LName: 'Khan', Gender: 'F', TelNo: '07916198679', Email: 'marcos.langworth@gmail.com', EA_ID:'EA2'},
  {_id: '5', FName: 'Houston', LName: 'Riley', Gender: 'F', TelNo: '07085578652', Email: 'fgleichner@gmail.com', EA_ID:'EA2'},
  {_id: '6', FName: 'Weston', LName: 'Day', Gender: 'M', TelNo: '07027664238', Email: 'kira27@yahoo.com', EA_ID:'EA3'},
  {_id: '7', FName: 'Ishaan', LName: 'Patel', Gender: 'M', TelNo: '07048672644', Email: 'zlesch@haag.org', EA_ID:'EA3'},
  {_id: '8', FName: 'Dorothy', LName: 'Riley', Gender: 'M', TelNo: '07936565788', Email: 'kshlerin.kolby@heaney.biz', EA_ID:'EA4'},
  {_id: '9', FName: 'Carol', LName: 'John', Gender: 'M', TelNo: '07900120748', Email: 'mcglynn.rigoberto@metz.biz', EA_ID:'EA4'},
  {_id: '10', FName: 'Kevin', LName: 'Gallagher', Gender: 'F', TelNo: '07874117505', Email: 'stoltenberg.leon@marks.com', EA_ID:'EA5'},
  {_id: '11', FName: 'Ash', LName: 'Moreno', Gender: 'M', TelNo: '07808266601', Email: 'ZaraCassidy9642@bungar.biz', EA_ID:'EA5'},
  {_id: '12', FName: 'Jesse', LName: 'Stone', Gender: 'F', TelNo: '07861412454', Email: 'Angel_Graves1062@elnee.tech', EA_ID:'EA2'},
  {_id: '13', FName: 'Mel', LName: 'Brown', Gender: 'F', TelNo: '07915449873', Email: 'Rocco_Malone7511@guentu.biz', EA_ID:'EA3'},
  {_id: '14', FName: 'Ashley', LName: 'Richardson', Gender: 'F', TelNo: '07852339755', Email: 'Logan_Booth6889@bauros.biz', EA_ID:'EA4'},
  {_id: '15', FName: 'Gale', LName: 'Sawyer', Gender: 'M', TelNo: '07941316564', Email: 'Maya_Craig2146@deons.tech', EA_ID:'EA5'},
    ])

db.Branch.insertMany([
  {_id:'1', EA_ID:'EA1', StaffManager: '1', POSTCODE: 'NE12AE', STREET: 'MENSWORTH', BR_TYPE: 'HQ'},
  {_id:'2', EA_ID:'EA5', StaffManager: '11', POSTCODE: 'NE12AE', STREET: 'BROWN', BR_TYPE: 'HQ'},
  {_id:'3', EA_ID:'EA2', StaffManager: '4', POSTCODE: 'GH12AE', STREET: 'RATE', BR_TYPE: 'BR'},
  {_id:'4', EA_ID:'EA3', StaffManager: '6', POSTCODE: 'LD12AE', STREET: 'MANCHY', BR_TYPE: 'BR'},
  {_id:'5', EA_ID:'EA4', StaffManager: '8', POSTCODE: 'GH12AE', STREET: 'STODDART', BR_TYPE: 'BR'},
  {_id:'6', EA_ID:'EA5', StaffManager: '15', POSTCODE: 'DH12AE', STREET: 'JEREMY', BR_TYPE: 'BR'},
  {_id:'7', EA_ID:'EA4', StaffManager: '9', POSTCODE: 'NE12AE', STREET: 'CEEJAY', BR_TYPE: 'HQ'},
  {_id:'8', EA_ID:'EA3', StaffManager: '13', POSTCODE: 'DH12AE', STREET: 'BURNA', BR_TYPE: 'HQ'},
  {_id:'9', EA_ID:'EA2', StaffManager: '12', POSTCODE: 'DH12AE', STREET: 'QUEEN', BR_TYPE: 'HQ'},
  {_id:'10', EA_ID:'EA1', StaffManager: '3', POSTCODE: 'LD12AE', STREET: 'BACKSTREET', BR_TYPE: 'BR'}
  ])

db.Address.insertMany([
  {_id: 'NE12AE', suburb: 'Hylton Castle', city: 'Newcastle'},
  {_id: 'NE13AE', suburb: 'Jesmond', city: 'Newcastle'},
  {_id: 'GH12AE', suburb: 'Low Fell', city: 'Gateshead'},
  {_id: 'DH12AE', suburb: 'Denton Burn', city: 'Durham'},
  {_id: 'LD12AE', suburb: 'Ryton', city: 'Sunderland'}
])


db.createView (
  "STAFF_EA",
    "Staff",
  [
    { $lookup: 
      { from: "Estate_Agent",
       localField: "EA_ID",
       foreignField: "_id",
       as: "Agency"
      }
    }
  ]
);

db.STAFF_EA.find({}, {LName:1, "Agency.EAName":1});





db.Estate_Agent.find();
db.Staff.find();
db.Branch.find();
db.Address.find();

db.Branch.aggregate ([
 {
   $lookup:
     {
       from: "Staff",
       localField: "StaffManager",
       foreignField: "_id",
       as: "Manager"
     }
 }
]);

db.Staff.aggregate ([
 {
   $lookup:
     {
       from: "Estate_Agent",
       localField: "EAName",
       foreignField: "_id",
       as: "Estate Agent"
     }
 }
]);