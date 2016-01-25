local m = {}
Aux.listing_util = m

function m.money_column(name, getter)
    return {
        title = name,
        width = 80,
        comparator = function(datum1, datum2) return Aux.util.compare(getter(datum1), getter(datum2), Aux.util.GT) end,
        cell_initializer = Aux.sheet.default_cell_initializer('RIGHT'),
        cell_setter = function(cell, datum)
            cell.text:SetText(Aux.util.money_string(getter(datum)))
--            group_alpha_setter(cell, getter(datum))
        end,
    }
end

function m.percentage_market_column(item_key_getter, value_getter)
        return {
            title = 'Pct',
            width = 40,
            comparator = function(datum1, datum2)
                local market_price1 = Aux.history.market_value(item_key_getter(datum1))
                local market_price2 = Aux.history.market_value(item_key_getter(datum2))
                local factor1 = market_price1 > 0 and value_getter(datum1) / market_price1
                local factor2 = market_price2 > 0 and value_getter(datum2) / market_price2
                return Aux.util.compare(factor1, factor2, Aux.util.GT)
            end,
            cell_initializer = Aux.sheet.default_cell_initializer('RIGHT'),
            cell_setter = function(cell, datum)
                local market_price = Aux.history.market_value(item_key_getter(datum))

                local pct = market_price > 0 and ceil(100 / market_price * value_getter(datum))
                if not pct then
                    cell.text:SetText('N/A')
                elseif pct > 999 then
                    cell.text:SetText('>999%')
                else
                    cell.text:SetText(pct..'%')
                end
                if pct then
                    cell.text:SetTextColor(Aux.price_level_color(pct))
                end
            end,
        }
end