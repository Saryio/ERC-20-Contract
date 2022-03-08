pragma solidity 0.8.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract ToniToken is ERC20{

    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // event Approval(address indexed _owner, address indexed _spender, uint256 _value)
    // event Transfer(address indexed _from, address indexed _to, uint256 _value)

    constructor(uint256 initialSupply) ERC20("Toni", "TATC") {
        _mint(msg.sender, initialSupply);
    }

    function _mint(address account, uint256 value) override internal{
        _totalSupply += value;
        _balances[account] += value;
        emit Transfer(address(0), account, value);
    }

    function decimals() public override pure returns(uint8){
        return 8;
    }

    function totalSupply() public view override returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view override returns(uint256 balance){
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public override returns(bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(address _sender, address _recipient, uint256 _value)override internal{
        uint256 senderBalance = _balances[_sender];
        require(senderBalance >= _value, "Valor eh acima do saldo da carteira" );

        unchecked{
            _balances[_sender] = senderBalance - _value;
        }

        _balances[_recipient] += _value;

        emit Transfer(_sender, _recipient, _value);
    }

    function transferFrom(address sender, address recipient, uint256 value) public override returns(bool){
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= value, "ERC20: transfer amount exceds allowance");
        _transfer(sender, recipient, value);
        _approve(sender, msg.sender, currentAllowance - value);

        return true;
    }

    function approve(address spender, uint256 value) public override returns(bool){
        _approve(msg.sender, spender, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns(bool){
        _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns(bool){
        uint256 currentAllowances = _allowances[msg.sender][spender];
        require(currentAllowances>= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked{
            _approve(msg.sender, spender, currentAllowances - subtractedValue);
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 value) internal override{
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}