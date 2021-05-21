module RandyBasics

	module Sort

		protected
		def self.getMode (par)
			if par == '>'
				return -> (x,y) {return x > y}
			else
				#puts "No specific mode given or ascending specified. Sorting ascending"
				return ->(x,y) {return x < y}
			end
		end
		
		def self.isArray? (arg) 
			if !arg.is_a? Array || arg.size < 1
				#puts "WARNING: No array to sort or array empty. No sorting done."
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
		
		def self.mergeSortP (arg, comp) 
			if arg.size < 2
				return arg
			end
			l = mergeSortP(arg.slice(0...arg.size/2), comp) + [Float::INFINITY]
			r = mergeSortP(arg.slice(arg.size/2...arg.size), comp) + [Float::INFINITY]
			i,j = 0, 0
			while i+j < arg.size do
				if i >= l.size
					arg[i+-1] = r[j]
					j += 1
				elsif j >= r.size
					arg[i+j-1] = l[i]
					i += 1
				elsif comp.call(l[i], r[j])
					arg[i+j] = l[i]
					i += 1
				else
					arg[i+j] = r[j]
					j += 1
				end
			end
			return arg
		end
		
		
		
		public
		def self.quickSort(arg, *par)
			unless isArray?(arg)
				return arg
			end
		
			comp = getMode(par[0])
			
			#puts "Performing quickSort..."
			return quickSortP arg, comp
		end

		def self.insertionSort (arg, *par)

			unless isArray? arg
				return arg
			end

			comp = getMode(par[0])

			#puts "Performing insertionSort..."
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

		def self.mergeSort (arg, *par)
			unless isArray? arg
				return arg
			end

			comp = getMode(par[0])

			return mergeSortP(arg, comp)
		end

	end


	module DataStructures
		protected
		class Element 
			attr_accessor :content, :nxt
			def initialize arg, *nxtarg
				@content = arg
				@nxt = nxtarg[0]
			end
			def getDataType 
				return arg.class
			end
		end

		class ClosedQueueError < StopIteration

		end

		public
		class Stack 
			attr_accessor :first, :size
			attr_reader :closed

			def initialize
				@dummy = Element.new(nil)
				@dummy.nxt = @dummy
				@first = @dummy
				@size = 0
				@closed = false
			end
			def << arg
				if closed?
					raise ClosedQueueError, "Stack already closed"
				end
				if arg != nil
					@first = Element.new arg, @first
					@size += 1
				else 
					raise ArgumentError, "No content given."
				end
			end
			alias :push, :<<
			def pop 
				unless empty?
					res = @first.content
					@first = @first.nxt
					@size -= 1
					return res
				end
				raise IndexError, "Stack empty"
				return nil
			end
			def empty? 
				return @first.content == nil
			end
			def toArray
				array = []
				cur = @first
				until cur.content == nil
					array[array.size] = cur.content
					cur = cur.nxt
				end
				return array
			end
			def clear
				@first = @dummy
				@size = 0
			end
			def close
				@closed = true
			end
		end

		class Queue 
			attr_accessor :first, :size
			attr_reader :closed
			alias :length, :size
			 def initialize
				@dummy = Element.new(nil)
				@dummy.nxt = @dummy
				@first = @dummy
				@size = 0
				@closed = false
			end
			def << arg
				if closed?
					raise ClosedQueueError, "Queue closed"
				end
				if arg != nil
					if empty? 
						@dummy.nxt = Element.new(arg, @dummy)
						@first = @dummy.nxt
					else
						@dummy.nxt.nxt = Element.new(arg, @dummy)
						@dummy.nxt = @dummy.nxt.nxt
					end
					@size += 1
				else 
					raise ArgumentError, "No content given"
				end
			end
			alias :push, :<<
			alias :queue, :<<
			alias :enq, :<<
			def pop 
				unless empty?
					res = @first.content
					@first = @first.nxt
					@size -= 1
					return res
				end
				raise IndexError, "Queue empty"
				return nil
			end
			alias :deq, :pop
			alias :dequeue, :pop
			alias :shift, :pop
			def empty? 
				return @first.content == nil
			end
			def toArray
				array = []
				cur = @first
				until cur.content == nil
					array[array.size] = cur.content
					cur = cur.nxt
				end
				return array
			end
			def clear 
				@first = @dummy
				@size = 0
			end
			def close
				closed = true
			end
		end
	end

end