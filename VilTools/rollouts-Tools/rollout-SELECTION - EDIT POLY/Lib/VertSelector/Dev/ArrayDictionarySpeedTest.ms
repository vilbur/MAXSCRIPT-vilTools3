clearListener(); print("Cleared in:\n"+getSourceFileName())




--max_count = 1000
--max_count = 10000
max_count = 100000	-- 100.000
--max_count = 100000	-- 1.000.000


dictionary_test = Dictionary #string
array_test = #()
bitarray_test = #()



DICTIONARY_WRITE = timeStamp()
for i = 1 to max_count do
	dictionary_test[i as string ] = i
format "\n DICTIONARY_WRITE: % ms\n" (( timeStamp()) - DICTIONARY_WRITE)


DICTIONARY_READ = timeStamp()
for key in dictionary_test.keys do
	val = dictionary_test[key]
format "\n DICTIONARY_READ: % ms\n" (( timeStamp()) - DICTIONARY_READ)







ARRAY_WRITE = timeStamp()
for i = 1 to max_count do
	array_test[i] = i
format "\n ARRAY_WRITE: % ms\n" (( timeStamp()) - ARRAY_WRITE)


ARRAY_READ = timeStamp()
for i = 1 to max_count do
	val = array_test[i] = i
format "\n ARRAY_READ: % ms\n" (( timeStamp()) - ARRAY_READ)





BITARRAY_WRITE = timeStamp()
for i = 1 to max_count do
	array_test[i] = true
format "\n BITARRAY_WRITE: % ms\n" (( timeStamp()) - BITARRAY_WRITE)


BITARRAY_READ = timeStamp()
for i = 1 to max_count do
	val =  array_test[i]
format "\n BITARRAY_READ: % ms\n" (( timeStamp()) - BITARRAY_READ)
