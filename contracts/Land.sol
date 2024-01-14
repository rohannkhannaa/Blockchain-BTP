pragma solidity >= 0.5.2;
pragma experimental ABIEncoderV2;
contract Land { // RFP
    struct RfpReg { // RfpReg
        uint id;
        uint area;
        string city;
        string state;
        uint rfpPrice;
        uint rfpssId;
        uint physicalSurveyNumber;
        string ipfsHash;
        string document;
    }

    struct DevAgency{ //DevAgency
        address id;
        string name;
        uint age;
        string city;
        string aadharNumber;
        string panNumber;
        string document;
        string email;
    }

    struct Shq{ // Shq
        address id;
        string name;
        uint age;
        string aadharNumber;
        string panNumber;
        string rfpssOwned;
        string document;
    }

    struct ContractAdmin { // Admin
        uint id;
        string name;
        uint age;
        string designation;
    }

    struct BidRequest{ //BidRequest
        uint reqId;
        address shqqId;
        address agencyyId;
        uint rfpssId;
        // bool requestStatus;
        // bool requested;
    }

    //key value pairs
    mapping(uint => RfpReg) public rfps;
    mapping(uint => ContractAdmin) public AdminMapping;
    mapping(address => Shq) public ShqMapping;
    mapping(address => DevAgency) public AgencyMapping;
    mapping(uint => BidRequest) public BidsMapping;

    mapping(address => bool) public RegisteredAddressMapping;
    mapping(address => bool) public RegisteredShqMapping;
    mapping(address => bool) public RegisteredAgencyMapping;
    mapping(address => bool) public ShqVerification;
    mapping(address => bool) public ShqRejection;
    mapping(address => bool) public AgencyVerification;
    mapping(address => bool) public AgencyRejection;
    mapping(uint => bool) public RfpVerification;
    mapping(uint => address) public RfpOwner;
    mapping(uint => bool) public RequestStatus;
    mapping(uint => bool) public RequestedRfp;
    mapping(uint => bool) public PaymentReceived;

    address public RfpAdmin;
    address[] public shqList;
    address[] public agencyList;

    uint public rfpCount;
    uint public adminCount;
    uint public agencyCount;
    uint public shqCount;
    uint public requestsCount;

    event Registration(address _registrationId);
    event AddingRfp(uint indexed _landId);
    event Rfprequested(address _sellerId);
    event requestApproved(address _buyerId);
    event Verified(address _id);
    event Rejected(address _id);

    constructor() public{
        RfpAdmin = msg.sender ;
        addAdmin("Inspector 1", 45, "Tehsil Manager");
    }

    // addAdmin
    function addAdmin(string memory _name, uint _age, string memory _designation) private {
        adminCount++;
        AdminMapping[adminCount] = ContractAdmin(adminCount, _name, _age, _designation);
    }

    // getRfpCount
    function getRfpCount() public view returns (uint) {
        return rfpCount;
    }

    // getAgencyCount
    function getAgencyCount() public view returns (uint) {
        return shqCount;
    }

    // getShqCount
    function getShqCount() public view returns (uint) {
        return agencyCount;
    }

    // getBidCount
    function getBidCount() public view returns (uint) {
        return requestsCount;
    }

    function getArea(uint i) public view returns (uint) {
        return rfps[i].area;
    }
    function getCity(uint i) public view returns (string memory) {
        return rfps[i].city;
    }
     function getState(uint i) public view returns (string memory) {
        return rfps[i].state;
    }
    // function getStatus(uint i) public view returns (bool) {
    //     return rfps[i].verificationStatus;
    // }
    function getPrice(uint i) public view returns (uint) {
        return rfps[i].rfpPrice;
    }
    function getPID(uint i) public view returns (uint) {
        return rfps[i].rfpssId;
    }
    function getSurveyNumber(uint i) public view returns (uint) {
        return rfps[i].physicalSurveyNumber;
    }
    function getImage(uint i) public view returns (string memory) {
        return rfps[i].ipfsHash;
    }
    function getDocument(uint i) public view returns (string memory) {
        return rfps[i].document;
    }
    
    function getLandOwner(uint id) public view returns (address) {
        return RfpOwner[id];
    }

    // verifyShq
    function verifyShq(address _sellerId) public{
        require(isAdmin(msg.sender));

        ShqVerification[_sellerId] = true;
        emit Verified(_sellerId);
    }
    
    // rejectShq 
    function rejectShq(address _sellerId) public{
        require(isAdmin(msg.sender));

        ShqRejection[_sellerId] = true;
        emit Rejected(_sellerId);
    }

    // verifyAgency
    function verifyAgency(address _buyerId) public{
        require(isAdmin(msg.sender));

        AgencyVerification[_buyerId] = true;
        emit Verified(_buyerId);
    }
    // rejectAgency
    function rejectAgency(address _buyerId) public{
        require(isAdmin(msg.sender));

        AgencyRejection[_buyerId] = true;
        emit Rejected(_buyerId);
    }
    
    // verifyRfp
    function verifyRfp(uint _landId) public{
        require(isAdmin(msg.sender));

        RfpVerification[_landId] = true;
    }

    // isRfpVerified
    function isRfpVerified(uint _id) public view returns (bool) {
        if(RfpVerification[_id]){
            return true;
        }
    }

    
    function isVerified(address _id) public view returns (bool) {
        if(ShqVerification[_id] || AgencyVerification[_id]){
            return true;
        }
    }

    function isRejected(address _id) public view returns (bool) {
        if(ShqRejection[_id] || AgencyRejection[_id]){
            return true;
        }
    }

    // isAgency
    function isAgency(address _id) public view returns (bool) {
        if(RegisteredShqMapping[_id]){
            return true;
        }
    }

    // isAdmin
    function isAdmin(address _id) public view returns (bool) {
        if(RfpAdmin == _id){
            return true;
        }else{
            return false;
        }
    }

    // isShq
    function isShq(address _id) public view returns (bool) {
        if(RegisteredAgencyMapping[_id]){
            return true;
        }
    }

    function isRegistered(address _id) public view returns (bool) {
        if(RegisteredAddressMapping[_id]){
            return true;
        }
    }

    // addRfp
    function addRfp(uint _area, string memory _city,string memory _state, uint rfpPrice, uint _propertyPID,uint _surveyNum,string memory _ipfsHash, string memory _document) public {
        require((isAgency(msg.sender)) && (isVerified(msg.sender)));
        rfpCount++;
        rfps[rfpCount] = RfpReg(rfpCount, _area, _city, _state, rfpPrice,_propertyPID, _surveyNum, _ipfsHash, _document);
        RfpOwner[rfpCount] = msg.sender;
        // emit AddingRfp(rfpCount);
    }

    //registration of seller
    // registerShq
    function registerShq(string memory _name, uint _age, string memory _aadharNumber, string memory _panNumber, string memory _landsOwned, string memory _document) public {
        //require that Shq is not already registered
        require(!RegisteredAddressMapping[msg.sender]);

        RegisteredAddressMapping[msg.sender] = true;
        RegisteredShqMapping[msg.sender] = true ;
        agencyCount++;
        ShqMapping[msg.sender] = Shq(msg.sender, _name, _age, _aadharNumber,_panNumber, _landsOwned, _document);
        shqList.push(msg.sender);
        emit Registration(msg.sender);
    }

    // updateShq
    function updateShq(string memory _name, uint _age, string memory _aadharNumber, string memory _panNumber, string memory _landsOwned) public {
        //require that Shq is already registered
        require(RegisteredAddressMapping[msg.sender] && (ShqMapping[msg.sender].id == msg.sender));

        ShqMapping[msg.sender].name = _name;
        ShqMapping[msg.sender].age = _age;
        ShqMapping[msg.sender].aadharNumber = _aadharNumber;
        ShqMapping[msg.sender].panNumber = _panNumber;
        ShqMapping[msg.sender].rfpssOwned = _landsOwned;

    }
    // getShq
    function getShq() public view returns( address [] memory ){
        return(shqList);
    }

    // getShqDetails
    function getShqDetails(address i) public view returns (string memory, uint, string memory, string memory, string memory, string memory) {
        return (ShqMapping[i].name, ShqMapping[i].age, ShqMapping[i].aadharNumber, ShqMapping[i].panNumber, ShqMapping[i].rfpssOwned, ShqMapping[i].document);
    }

    // registerAgency
    function registerAgency(string memory _name, uint _age, string memory _city, string memory _aadharNumber, string memory _panNumber, string memory _document, string memory _email) public {
        //require that DevAgency is not already registered
        require(!RegisteredAddressMapping[msg.sender]);

        RegisteredAddressMapping[msg.sender] = true;
        RegisteredAgencyMapping[msg.sender] = true ;
        shqCount++;
        AgencyMapping[msg.sender] = DevAgency(msg.sender, _name, _age, _city, _aadharNumber, _panNumber, _document, _email);
        agencyList.push(msg.sender);

        emit Registration(msg.sender);
    }

    // updateAgency
    function updateAgency(string memory _name,uint _age, string memory _city,string memory _aadharNumber, string memory _email, string memory _panNumber) public {
        //require that DevAgency is already registered
        require(RegisteredAddressMapping[msg.sender] && (AgencyMapping[msg.sender].id == msg.sender));

        AgencyMapping[msg.sender].name = _name;
        AgencyMapping[msg.sender].age = _age;
        AgencyMapping[msg.sender].city = _city;
        AgencyMapping[msg.sender].aadharNumber = _aadharNumber;
        AgencyMapping[msg.sender].email = _email;
        AgencyMapping[msg.sender].panNumber = _panNumber;
        
    }

    // getAgency
    function getAgency() public view returns( address [] memory ){
        return(agencyList);
    }

    // getAgencyDetails
    function getAgencyDetails(address i) public view returns ( string memory,string memory, string memory, string memory, string memory, uint, string memory) {
        return (AgencyMapping[i].name,AgencyMapping[i].city , AgencyMapping[i].panNumber, AgencyMapping[i].document, AgencyMapping[i].email, AgencyMapping[i].age, AgencyMapping[i].aadharNumber);
    }

    // requestBid
    function requestBid(address _sellerId, uint _landId) public{
        require(isShq(msg.sender) && isVerified(msg.sender));
        
        requestsCount++;
        BidsMapping[requestsCount] = BidRequest(requestsCount, _sellerId, msg.sender, _landId);
        RequestStatus[requestsCount] = false;
        RequestedRfp[requestsCount] = true;

        emit Rfprequested(_sellerId);
    }

    // getBidDetails
    function getBidDetails (uint i) public view returns (address, address, uint, bool) {
        return(BidsMapping[i].shqqId, BidsMapping[i].agencyyId, BidsMapping[i].rfpssId, RequestStatus[i]);
    }

    function isRequested(uint _id) public view returns (bool) {
        if(RequestedRfp[_id]){
            return true;
        }
    }

    function isApproved(uint _id) public view returns (bool) {
        if(RequestStatus[_id]){
            return true;
        }
    }

    function approveRequest(uint _reqId) public {
        require((isAgency(msg.sender)) && (isVerified(msg.sender)));
       
        RequestStatus[_reqId] = true;

    }

    function RfpOwnershipTransfer(uint _landId, address _newOwner) public{
        require(isAdmin(msg.sender));

        RfpOwner[_landId] = _newOwner;
    }

    function isPaid(uint _landId) public view returns (bool) {
        if(PaymentReceived[_landId]){
            return true;
        }
    }

    function payment(address payable _receiver, uint _landId) public payable {
        PaymentReceived[_landId] = true;
        _receiver.transfer(msg.value);
    }
}
