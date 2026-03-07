
from selenium.webdriver import By
from selenium.webdriver.support import wait

ProductPrices=(By.Xpath,"//div[@data-test='inventory-item-price']")

ProductPriceList=find_elements(ProductPrices)

PriceList=[]
for i in len(ProductPriceList):
    CurrencyPrice=ProductPriceList[i].text
    Price=CurrencyPrice.split(" ")
    PriceList.append(Price[1])

print(min(PriceList))




# Robot Framework Code:

ProductPrices   xpath="//div[@data-test='inventory-item-price']"  
ProductPriceLocators    GetElements     

@

For i  in range ProductPriceLocators
    CurrencyPrice  Get Text ProductPriceLocators[i]
    Price  Split String  CurrencyPrice
    Price   set variable Price[1]


    




