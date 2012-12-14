class PageRank
    attr_accessor :pr , :n , :outlinks, :counter , :m , :s , :round
    def initialize(file)
    	@filename = file
        @pr = Hash.new(0)
        @outlinks = Hash.new(0)
        @m = Hash.new(0)
        @s = Array.new(0)
        @n = 0
        @counter = 0
        @round = 1
    end
    
    def countlines()
    	puts "The links file to be processed is #{@filename} "
    	File.foreach(@filename) { |line| @n += 1 }
    	puts "The number of pages is #{@n}"
    end

    def setdefault()
    	File.foreach(@filename) do |line| 
    		arr = line.strip.split(/ /)
    		@pr[arr[0]] = (1/@n.to_f)
    	end
    end
    
    def outlinkz()
        File.foreach(@filename) do |line|
            arr = line.strip.split(/ /)
            @outlinks[arr[0]] = 0.0
        end
        File.foreach(@filename) do |line|
            ar = []
            arr = line.strip.split(/ /)
            arr[1..arr.length].each do |elem|
                ar << elem
            end
            @m[arr[0]] = ar
        end
        @m.each do |key,val|
                val.each do |x|
                    @outlinks[x] += 1.0
                end
        end
        @outlinks.each do |x,y|
            if y == 0
                @s << x
            end
        end
        #puts @outlinks
    end

    def pgrank()
        sinkPr = 0.00
        newPR = Hash.new(0)
        oldval = 0.0
        d = 0.85
        perple = perplexity(@pr)
        while(not converge(oldval,perple))
            oldval = perple
            sinkPr = 0.00
            @s.each do |p|
                    sinkPr += @pr[p].to_f
            end
            File.foreach(@filename) do |line|
                arr = line.strip.split(/ /)
                newPR[arr[0]] = ((1.0-d)/@n.to_f)
                newPR[arr[0]] += (d *(sinkPr.to_f/@n.to_f))
                @m[arr[0]].each do |q|
                   newPR[arr[0]] += (d * (@pr[q].to_f/ @outlinks[q].to_f))
                end
            end
            @pr = newPR.dup
            perple = perplexity(@pr)
        end
        return @pr
    end

    def perplexity(hash1)
        sum = 0.0
        hash1.each do |x,y|
           sum += (y.to_f * Math.log2(y.to_f))
        end
        perplex = (2.to_f ** (-1.to_f * sum)).to_f
        puts "round = #{@round}   perplexity = #{perplex}"
        @round += 1
        return perplex
    end

    def converge(oldval,perpl)
        if @counter == 3
            return TRUE
        else
            if oldval.floor == perpl.to_f.floor
                @counter += 1
                return FALSE
            else
                @counter = 0
                return FALSE
            end
        end
    end
end

p_rank = PageRank.new('wt2g_inlinks.txt')
p_rank.countlines()
p_rank.setdefault()
p_rank.outlinkz()
pagerankhash = Hash.new(0)
pagerankhash = p_rank.pgrank()
pagerankhash = pagerankhash.sort_by{|k,v| v}.reverse
rank  = 0
pagerankhash.each do |k,v|
    if rank == 10
        break
    else
        rank += 1
    end
    puts "#{k}  #{v}"
end
