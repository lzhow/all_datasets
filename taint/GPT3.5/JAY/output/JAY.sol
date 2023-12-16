pragma solidity 0.8.17;


contract JAY is ERC20, Ownable {
    using SafeMath for uint256;
    AggregatorV3Interface internal priceFeed;

    address private dev;
    uint256 public constant MIN = 1000;
    bool private start = false;
    bool private lockDev = false;

    uint256 private nftsBought;
    uint256 private nftsSold;

    uint256 private buyNftFeeEth = 0.01 * 10**18;
    uint256 private buyNftFeeJay = 10 * 10**18;

    uint256 private sellNftFeeEth = 0.001 * 10**18;

    uint256 private constant USD_PRICE_SELL = 2 * 10**18;
    uint256 private constant USD_PRICE_BUY = 10 * 10**18;

    uint256 private nextFeeUpdate = block.timestamp.add(7 days);

    event Price(uint256 time, uint256 price);

    constructor() payable ERC20("JayPeggers", "JAY") {
        require(msg.value == 2 * 10**18);
        dev = msg.sender;
        _mint(msg.sender, 2 * 10**18 * MIN);
        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //main
    }

    function updateDevWallet(address _address) public onlyOwner {
        require(lockDev == false);
        dev = _address;
    }
    function lockDevWallet() public onlyOwner {
        lockDev = true;
    }

    function startJay() public onlyOwner {
        start = true;
    }

    // Buy NFTs from Vault
    function buyNFTs(
        address[] calldata erc721TokenAddress,
        uint256[] calldata erc721Ids,
        address[] calldata erc1155TokenAddress,
        uint256[] calldata erc1155Ids,
        uint256[] calldata erc1155Amounts
    ) public payable {
        uint256 total = erc721TokenAddress.length;
        if (total != 0) buyERC721(erc721TokenAddress, erc721Ids);

        if (erc1155TokenAddress.length != 0)
            total = total.add(
                buyERC1155(erc1155TokenAddress, erc1155Ids, erc1155Amounts)
            );

        require(
            msg.value >= (total).mul(buyNftFeeEth),
            "You need to pay ETH more"
        );
        (bool success, ) = dev.call{value: msg.value.div(2)}("");
        require(success, "ETH Transfer failed.");
        _burn(msg.sender, total.mul(buyNftFeeJay));
        nftsBought += total;

        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
    }

    function buyERC721(address[] calldata _tokenAddress, uint256[] calldata ids)
        internal
    {
        for (uint256 id = 0; id < ids.length; id++) {
            IERC721(_tokenAddress[id]).safeTransferFrom(
                address(this),
                msg.sender,
                ids[id]
            );
        }
    }

    function buyERC1155(
        address[] calldata _tokenAddress,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) internal returns (uint256) {
        uint256 amount = 0;
        for (uint256 id = 0; id < ids.length; id++) {
            amount = amount.add(amounts[id]);
            IERC1155(_tokenAddress[id]).safeTransferFrom(
                address(this),
                msg.sender,
                ids[id],
                amounts[id],
                ""
            );
        }
        return amount;
    }

    // Sell NFTs (Buy Jay)
    function buyJay(
        address[] calldata erc721TokenAddress,
        uint256[] calldata erc721Ids,
        address[] calldata erc1155TokenAddress,
        uint256[] calldata erc1155Ids,
        uint256[] calldata erc1155Amounts
    ) public payable {
        require(start, "Not started!");
        uint256 total = erc721TokenAddress.length;
        if (total != 0) buyJayWithERC721(erc721TokenAddress, erc721Ids);

        if (erc1155TokenAddress.length != 0)
            total = total.add(
                buyJayWithERC1155(
                    erc1155TokenAddress,
                    erc1155Ids,
                    erc1155Amounts
                )
            );

        if (total >= 100)
            require(
                msg.value >= (total).mul(sellNftFeeEth).div(2),
                "You need to pay ETH more"
            );
        else
            require(
                msg.value >= (total).mul(sellNftFeeEth),
                "You need to pay ETH more"
            );

        _mint(msg.sender, ETHtoJAY(msg.value).mul(97).div(100));

        (bool success, ) = dev.call{value: msg.value.div(34)}("");
        require(success, "ETH Transfer failed.");

        nftsSold += total;

        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
    }

    function buyJayWithERC721(
        address[] calldata _tokenAddress,
        uint256[] calldata ids
    ) internal {
        for (uint256 id = 0; id < ids.length; id++) {
            IERC721(_tokenAddress[id]).transferFrom(
                msg.sender,
                address(this),
                ids[id]
            );
        }
    }

    function buyJayWithERC1155(
        address[] calldata _tokenAddress,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) internal returns (uint256) {
        uint256 amount = 0;
        for (uint256 id = 0; id < ids.length; id++) {
            amount = amount.add(amounts[id]);
            IERC1155(_tokenAddress[id]).safeTransferFrom(
                msg.sender,
                address(this),
                ids[id],
                amounts[id],
                ""
            );
        }
        return amount;
    }

    // Sell Jay
    function sell(uint256 value) public {
        require(value > MIN, "Dude tf");

        uint256 eth = JAYtoETH(value);
        _burn(msg.sender, value);

        (bool success, ) = msg.sender.call{value: eth.mul(90).div(100)}("");
        require(success, "ETH Transfer failed.");
        (bool success2, ) = dev.call{value: eth.div(33)}("");
        require(success2, "ETH Transfer failed.");

        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
    }

    // Buy Jay (No NFT)
    function buyJayNoNFT() public payable {
        require(msg.value > MIN, "must trade over min");
        require(start, "Not started!");

        _mint(msg.sender, ETHtoJAY(msg.value).mul(85).div(100));

        (bool success, ) = dev.call{value: msg.value.div(20)}("");
        require(success, "ETH Transfer failed.");

        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
    }

    //utils
    function getBuyJayNoNFT(uint256 amount) public view returns (uint256) {
        return
            amount.mul(totalSupply()).div(address(this).balance).mul(85).div(
                100
            );
    }

    function getBuyJayNFT(uint256 amount) public view returns (uint256) {
        return
            amount.mul(totalSupply()).div(address(this).balance).mul(97).div(
                100
            );
    }

    function JAYtoETH(uint256 value) public view returns (uint256) {
        return (value * address(this).balance).div(totalSupply());
    }

    function ETHtoJAY(uint256 value) public view returns (uint256) {
        return value.mul(totalSupply()).div(address(this).balance.sub(value));
    }

    // chainlink pricefeed / fee updater
    function getFees()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (sellNftFeeEth, buyNftFeeEth, buyNftFeeJay, nextFeeUpdate);
    }

    function getTotals()
        public
        view
        returns (
            uint256,
            uint256
        )
    {
        return (nftsBought, nftsSold);
    }


    function updateFees()
        public
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        uint256 _price = uint256(price).mul(1 * 10**10);
        require(
            timeStamp > nextFeeUpdate,
            "Fee update every 24 hrs"
        );

        uint256 _sellNftFeeEth;
        if (_price > USD_PRICE_SELL) {
            uint256 _p = _price.div(USD_PRICE_SELL);
            _sellNftFeeEth = uint256(1 * 10**18).div(_p);
        } else {
            _sellNftFeeEth = USD_PRICE_SELL.div(_price);
        }

        require(
            owner() == msg.sender ||
                (sellNftFeeEth.div(2) < _sellNftFeeEth &&
                    sellNftFeeEth.mul(150) > _sellNftFeeEth),
            "Fee swing too high"
        );

        sellNftFeeEth = _sellNftFeeEth;

        if (_price > USD_PRICE_BUY) {
            uint256 _p = _price.div(USD_PRICE_BUY);
            buyNftFeeEth = uint256(1 * 10**18).div(_p);
        } else {
            buyNftFeeEth = USD_PRICE_BUY.div(_price);
        }
        buyNftFeeJay = ETHtoJAY(buyNftFeeEth);

        nextFeeUpdate = timeStamp.add(24 hours);
        return (sellNftFeeEth, buyNftFeeEth, buyNftFeeJay, nextFeeUpdate);
    }

    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

    //receiver helpers
    function deposit() public payable {}

    receive() external payable {}

    fallback() external payable {}

    function onERC1155Received(
        address,
        address from,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external pure returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }
}
