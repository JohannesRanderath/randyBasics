module RandyBasics

	module Sort

		protected
		def self.getMode (par)
			if par == '>'
				return -> (x,y) {return x > y}
			else
				puts "No specific mode given or ascending specified. Sorting ascending"
				return ->(x,y) {return x < y}
			end
		end
		
		def self.isArray? (arg) 
			if !arg.is_a? Array || arg.size < 1
				puts "WARNING: No array to sort or array empty. No sorting done."
				return nil
			end
			return arg
		end
		
		def self.quickSortP (arg, comp)
			if arg.size < 2
				return arg
			end
			l = []
			r = []
			piv = arg[-1]
			l[0] = piv
			
			for i in (0...arg.size-1) do
				e = arg[i]
				if e == piv && rand(2) == 1
					r[r.size] = e
				elsif comp.call(e, piv) 
					l[l.size] = e
				else
					r[r.size] = e
				end
			end
			return quickSortP(l, comp) + quickSortP(r, comp)
		end
		
		
		
		
		public
		def self.quickSort(arg, *par)
			unless isArray?(arg)
				return arg
			end
		
			comp = getMode(par[0])
		
			puts "Performing quickSort..."
			return quickSortP arg, comp
		end

		def self.insertionSort (arg, *par)

			unless isArray? arg
				return arg
			end

			comp = getMode(par[0])

			puts "Performing insertionSort..."
			for i in (1...arg.size) do

				j = 0
				while j < i
					if comp.call(arg[i], arg[j]) 	# if arg[j] > arg[i] because 1 is standard mode
						break
					end
					j+=1
				end

				tmp = arg[i] 					#insert arg[i] before arg[j]
				i.downto(j) do |k|
					arg[k] = arg[k-1]
				end
				arg[j] = tmp

			end
			return arg
		end

		def self.bubbleSort (arg, *par)
			unless isArray? arg
				return arg
			end

			comp = getMode(par[0])

			i = 1
			loop do 

				changed = false
				for j in (0...arg.size-i) do
					if comp.call(arg[j+1], arg[j]) #swap if arg[j+1] < arg[j]
						arg[j], arg[j+1] = arg[j+1], arg[j]
						changed = true
					end
				end
				i+=1

			break unless changed && i < arg.size
			end
			return arg
		end

		def self.selectionSort (arg, *par)
			unless isArray? arg
				return arg
			end

			comp = getMode(par[0])

			for i in (0...arg.size) do
				min = i
				for j in (i+1...arg.size) do
					if comp.call(arg[j], arg[min]) # if arg[j] < arg[min]
						min = j
					end
				end
				tmp = arg[min]
				(min-1).downto(i) do |j|
					arg[j+1] = arg[j]
				end
				arg[i] = tmp
			end	
			return arg
		end

	end

end