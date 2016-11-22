require 'alphaku'

class AlphakuController < ApplicationController
    def index
        
    end
    
    def alphaku_process
        rule = ["","0","1","2","3","4","5","6","7","8","9","alphaku","alphaku_process"]
        only_numbers = true
        
        params.each_value{ |value| only_numbers = false if !rule.include?(value) }
        
        sudoku_array1 = make_template(params)
        sudoku_array2 = make_template(params)
        
        @inserted_place = []
        0.upto(8){|row| 0.upto(8){|column| @inserted_place << [row,column] if sudoku_array1[row][column] != 0 } }
        p @inserted_place
        
        is_sudoku?(sudoku_array1) && only_numbers ? @answer = Alphaku.complete(sudoku_array1,sudoku_array2) : redirect_to("/", alert: '스도쿠 번호를 다시 한 번 확인해 주세요.')
    end
    
private
    def make_template(params)
        template = [
        [params["000"],params["001"],params["002"],params["010"],params["011"],params["012"],params["020"],params["021"],params["022"]],
        [params["003"],params["004"],params["005"],params["013"],params["014"],params["015"],params["023"],params["024"],params["025"]],
        [params["006"],params["007"],params["008"],params["016"],params["017"],params["018"],params["026"],params["027"],params["028"]],

        [params["100"],params["101"],params["102"],params["110"],params["111"],params["112"],params["120"],params["121"],params["122"]],
        [params["103"],params["104"],params["105"],params["113"],params["114"],params["115"],params["123"],params["124"],params["125"]],
        [params["106"],params["107"],params["108"],params["116"],params["117"],params["118"],params["126"],params["127"],params["128"]],

        [params["200"],params["201"],params["202"],params["210"],params["211"],params["212"],params["220"],params["221"],params["222"]],
        [params["203"],params["204"],params["205"],params["213"],params["214"],params["215"],params["223"],params["224"],params["225"]],
        [params["206"],params["207"],params["208"],params["216"],params["217"],params["218"],params["226"],params["227"],params["228"]]
        ]
        
        return template.each{ |ele| ele.map!{ |n| n.to_i } }
    end
    
    def is_sudoku?(template)
        result = true
        0.upto(8) do |row|
            0.upto(8) do |column|
                target = template[row][column]
                
                next if target === 0
                # horizontal condition
                condition1 = true
                0.upto(8) do |new_column|
                    if template[row][new_column] === target && new_column != column 
                        condition1 = false
                        break
                    end
                end
                
                # vertical condition
                condition2 = true
                0.upto(8) do |new_row|
                    if template[new_row][column] === target && new_row != row
                        condition2 = false
                        break
                    end
                end
                
                # 3x3 box condition
                condition3 = true
                
                val = column / 3 ; arrange = [(0..2).to_a,(3..5).to_a,(6..8).to_a]
                if row % 3 === 0
                    1.upto(2) do |y|
                        arrange[val].each do |new_column|
                            if target === template[row+y][new_column] && new_column != column
                                condition3 = false
                                break
                            end
                        end
                    end
                elsif row % 3 === 1
                  arrange[val].each do |new_column|
                    if target === template[row-1][new_column] || target === template[row+1][new_column] && new_column != column
                        condition3 = false
                        break
                    end
                  end
                else # if row % 3 === 2
                    1.upto(2) do |y|
                        arrange[val].each do |new_column|
                            if target === template[row-y][new_column] && new_column != column
                                condition3 = false
                                break
                            end
                        end
                    end
                end
                
                return false if !target.is_a?(Integer) || target > 9 || !(condition1 && condition2 && condition3) 
            end
        end
        
        result
    end
end
