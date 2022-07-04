#!/bin/bash

API_URL="https://api.binance.com/api"
API_VERSION="v3"
URI="$API_VERSION/ticker/24hr"
LIMIT=5

#####Question 1 & 2
top_Symbols()
{
curl --silent --location --request GET "$API_URL/$URI" --header "Content-Type: application/json" | jq -r '[.[]|{symbol,volume}| select(.symbol | contains("'$1'"))]|sort_by(.volume)|reverse|[limit('$LIMIT';.[]|{symbol})]|.[]|.symbol'|awk '{print}' ORS=','| sed 's/,*$//g'
}


#####Question 3

call_Depth()
{
get_Depth=$(curl --silent --location --request GET "$API_URL/$API_VERSION/depth?symbol=$2&limit=500" --header "Content-Type: application/json" | jq -r '[.'$1'[]|{"price":.[0],"qty":.[1]}]|sort_by(.price)|reverse|[limit(200;.[])]')

sum=0
count=$(echo "$get_Depth" | jq '.|length')
for ((j=0; j<$count; j++)); do
    price_val=$(echo "$get_Depth" | jq -r '.['$j'].price')
    qty_val=$(echo "$get_Depth" | jq -r '.['$j'].qty')
    sum=$(echo "$sum + ($price_val * $qty_val)" | bc)

done
echo "$1_"$i" total notional value of the 200 $1 is "$sum
}



total_Notional_Value()
{
get_Symbol=$(top_Symbols $1)

for i in $(echo $get_Symbol | sed "s/,/ /g")
    do
    call_Depth bids $i
    call_Depth asks $i
    done
}

#total_Notional_Value BTC


get_Book_Ticker()
{
curl --silent --location --request GET "$API_URL/$API_VERSION/ticker/bookTicker?symbol=$1" --header "Content-Type: application/json" | jq -r '.'
}

######Question 4
#
price_Spread()
{
get_Symbol=$(top_Symbols $1)

for i in $(echo $get_Symbol | sed "s/,/ /g")
do
    get_Ticker=$(get_Book_Ticker $i)
    bidPrice=$(echo "$get_Ticker" | jq '.bidPrice'| tr -d '"')
    askPrice=$(echo "$get_Ticker" | jq '.askPrice'| tr -d '"')
    priceSpread=$(echo "$askPrice - $bidPrice" | bc)
    echo "Price Spread of "$i" is 0"$priceSpread

done
}

######Question 5
#
price_Delta()
{
get_Symbol=$(top_Symbols $1)


for i in $(echo $get_Symbol | sed "s/,/ /g")
do
    get_Old_Ticker=$(get_Book_Ticker $i)
    
    sleep 10
    
    get_New_Ticker=$(get_Book_Ticker $i)
    
    bidOldPrice=$(echo "$get_Old_Ticker" | jq '.bidPrice'| tr -d '"')
    askOldPrice=$(echo "$get_Old_Ticker" | jq '.askPrice'| tr -d '"')
    priceOldDelta=$(echo "$askOldPrice - $bidOldPrice" | bc)
    
    bidNewPrice=$(echo "$get_New_Ticker" | jq '.bidPrice'| tr -d '"')
    askNewPrice=$(echo "$get_New_Ticker" | jq '.askPrice'| tr -d '"')
    priceNewDelta=$(echo "$askNewPrice - $bidNewPrice" | bc)
    
    abs=$(echo "$priceOldDelta - $priceNewDelta" | bc | tr -d -)
    
    echo "Price Absolute of "$i" is "$abs

done
}

top_Symbols BTC
top_Symbols USDT
total_Notional_Value BTC
price_Spread USDT
price_Delta USDT
