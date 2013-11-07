KHMER=~/dev/khmer

all: genome-reads.fa.kh genome-reads.fa.keep \
	random.x.genome-reads.fa.overlap \
	random.x.genome-reads.fa.keep.overlap \
	random.x.genome-reads.fa.keep.abundfilt.overlap \
	random.x.genome-reads.fa.keep.abundfilt.keep.overlap \
	transcript-reads.fa \
	transcript-reads.fa.kh transcript-reads.fa.keep \
	transcripts.x.transcript-reads.fa.overlap \
	transcripts.x.transcript-reads.fa.keep.overlap \
	transcripts.x.transcript-reads.fa.keep.abundfilt.overlap \
	transcripts.x.transcript-reads.fa.keep.abundfilt.keep.overlap \
	genome-reads.fa.map.cov genome-reads.fa.keep.map.cov \
	ecoli_ref-5m.fastq.map.cov ecoli_ref.fastq.bz2.keep.map.cov \
	ecoli_ref-5m.fastq.counts.cmp \
	genome-reads.fa.counts.cmp \
	mouse-5m.fq.counts.cmp \
	transcript-reads.fa.counts.cmp \
	calc-r2.txt \
	transcript-reads.fa.map.cov \
	mouse-5m.fq.map.cov \
	mouse-5m.fq.keep.map \
	transcript-reads.fa.keep.map \
	mouse-5m.fq.keep.map.cov \
	transcript-reads.fa.keep.map.cov \
	endbias-genome.txt endbias-transcripts.txt \
	read15.ranks \
	ecoli.rawreads.map.gz \
	staph.rawreads.map.gz \
	sar324.rawreads.map.gz \
	ecoli.rawreads.map.gz.cov \
	staph.rawreads.map.gz.cov \
	sar324.rawreads.map.gz.cov \
	ecoli.keep.rawreads.map.gz.cov \
	staph.keep.rawreads.map.gz.cov \
	sar324.keep.rawreads.map.gz.cov \
	sar_dn.x.sar_orig sar_orig.x.sar_dn \
	ecoli_ref.fastq.bz2.keep.assembly.fa \
	sar.keep.assembly.fa \
	staph.keep.assembly.fa \
	orig_vs_staph_assembly.report \
	orig_vs_ecoli_assembly.report \
	sar_assembly.report

copydata:
	rm -fr ../data/
	mkdir ../data/
	cp *.cov *.report *.ranks *.cmp *.txt ../data/

clean:
	rm -f `cat clean-list.txt`

cleankh:
	rm -f bacteria_mda_lane1.fastq.bz2.normC20k20.kh \
		bacteria_mda_lane7.fastq.bz2.normC20k20.kh \
		ecoli_ref.fastq.bz2.normC20k20.kh


calc-r2.txt: ecoli_ref-5m.fastq.counts.cmp genome-reads.fa.counts.cmp mouse-5m.fq.counts.cmp transcript-reads.fa.counts.cmp
	python calc-r2.py > calc-r2.txt

random.fa:
	python make-random-genome.py > random.fa

random.fa.hb: random.fa
	${KHMER}/sandbox/load-into-hashbits.py -k 20 -N 4 -x 1e8 random.fa.hb random.fa

transcripts.fa:
	python make-random-transcriptome.py > transcripts.fa

transcripts.fa.hb: transcripts.fa
	${KHMER}/sandbox/load-into-hashbits.py -k 20 -N 4 -x 1e8 transcripts.fa.hb transcripts.fa

genome-reads.fa: random.fa
	python make-reads.py random.fa > genome-reads.fa

transcript-reads.fa: transcripts.fa
	python make-biased-reads.py transcripts.fa > transcript-reads.fa

read15.ranks: genome-reads.fa.kh error-reads.fa
	python read-kmer-rank-dist.py genome-reads.fa.kh error-reads.fa

endbias-genome.txt: genome-reads.fa.keep.abundfilt.keep.kh random.fa
	python find-missing-kmers.py genome-reads.fa.keep.abundfilt.keep.kh random.fa endbias-genome.txt

endbias-transcripts.txt: transcript-reads.fa.keep.abundfilt.keep.kh transcripts.fa
	python find-missing-kmers.py transcript-reads.fa.keep.abundfilt.keep.kh transcripts.fa endbias-transcripts.txt

genome-reads.fa.kh: genome-reads.fa
	${KHMER}/scripts/load-into-counting.py -k 20 -N 4 -x 1e8 genome-reads.fa.kh genome-reads.fa

genome-reads.fa.keep genome-reads.fa.keep.kh: genome-reads.fa
	${KHMER}/scripts/normalize-by-median.py -k 20 -N 4 -x 1e8 -C 20 --savehash genome-reads.fa.keep.kh genome-reads.fa

genome-reads.fa.keep.abundfilt: genome-reads.fa.keep genome-reads.fa.keep.kh
	${KHMER}/scripts/filter-abund.py genome-reads.fa.keep.kh genome-reads.fa.keep

genome-reads.fa.keep.abundfilt.keep genome-reads.fa.keep.abundfilt.keep.kh: genome-reads.fa.keep.abundfilt
	${KHMER}/scripts/normalize-by-median.py -k 20 -N 4 -x 1e8 -C 5 --savehash genome-reads.fa.keep.abundfilt.keep.kh genome-reads.fa.keep.abundfilt

random.x.genome-reads.fa.overlap: genome-reads.fa random.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 random.fa random.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 random.fa.ht genome-reads.fa random.x.genome-reads.fa.overlap

random.x.genome-reads.fa.keep.overlap: genome-reads.fa.keep random.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 random.fa random.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 random.fa.ht genome-reads.fa.keep random.x.genome-reads.fa.keep.overlap

random.x.genome-reads.fa.keep.abundfilt.overlap: genome-reads.fa.keep.abundfilt random.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 random.fa random.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 random.fa.ht genome-reads.fa.keep.abundfilt random.x.genome-reads.fa.keep.abundfilt.overlap

random.x.genome-reads.fa.keep.abundfilt.keep.overlap: genome-reads.fa.keep.abundfilt.keep random.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 random.fa random.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 random.fa.ht genome-reads.fa.keep.abundfilt.keep random.x.genome-reads.fa.keep.abundfilt.keep.overlap

transcript-reads.fa.kh: transcript-reads.fa
	${KHMER}/scripts/load-into-counting.py -k 20 -N 4 -x 1e8 transcript-reads.fa.kh transcript-reads.fa

transcript-reads.fa.keep transcript-reads.fa.keep.kh: transcript-reads.fa
	${KHMER}/scripts/normalize-by-median.py -k 20 -N 4 -x 1e8 -C 20 --savehash transcript-reads.fa.keep.kh transcript-reads.fa

transcript-reads.fa.keep.abundfilt: transcript-reads.fa.keep transcript-reads.fa.keep.kh
	${KHMER}/scripts/filter-abund.py transcript-reads.fa.keep.kh transcript-reads.fa.keep

transcript-reads.fa.keep.abundfilt.keep transcript-reads.fa.keep.abundfilt.keep.kh: transcript-reads.fa.keep.abundfilt
	${KHMER}/scripts/normalize-by-median.py -k 20 -N 4 -x 1e8 -C 5 --savehash transcript-reads.fa.keep.abundfilt.keep.kh transcript-reads.fa.keep.abundfilt

transcripts.x.transcript-reads.fa.overlap: transcript-reads.fa transcripts.fa.hb
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 transcripts.fa.hb transcript-reads.fa transcripts.x.transcript-reads.fa.overlap

transcripts.x.transcript-reads.fa.overlap: transcript-reads.fa transcripts.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 transcripts.fa transcripts.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 transcripts.fa.ht transcript-reads.fa transcripts.x.transcript-reads.fa.overlap

transcripts.x.transcript-reads.fa.keep.overlap: transcript-reads.fa.keep transcripts.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 transcripts.fa transcripts.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 transcripts.fa.ht transcript-reads.fa.keep transcripts.x.transcript-reads.fa.keep.overlap

transcripts.x.transcript-reads.fa.keep.abundfilt.overlap: transcript-reads.fa.keep.abundfilt transcripts.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 transcripts.fa transcripts.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 transcripts.fa.ht transcript-reads.fa.keep.abundfilt transcripts.x.transcript-reads.fa.keep.abundfilt.overlap

transcripts.x.transcript-reads.fa.keep.abundfilt.keep.overlap: transcript-reads.fa.keep.abundfilt.keep transcripts.fa.hb
	python ${KHMER}/scripts/load-graph.py --no-build-tagset -k 20 -N 4 -x 1e8 transcripts.fa transcripts.fa
	python ${KHMER}/scripts/count-overlap.py -k 20 -N 4 -x 1e8 transcripts.fa.ht transcript-reads.fa.keep.abundfilt.keep transcripts.x.transcript-reads.fa.keep.abundfilt.keep.overlap

random.1.ebwt: random.fa
	bowtie-build random.fa random

transcripts.1.ebwt: transcripts.fa
	bowtie-build transcripts.fa transcripts

samfoo: random.fa transcripts.fa
	samtools faidx random.fa
	samtools faidx transcripts.fa

genome-reads.fa.map: random.1.ebwt genome-reads.fa
	bowtie -f -a --best --strata random genome-reads.fa > genome-reads.fa.map

genome-reads.fa.sam: random.1.ebwt genome-reads.fa
	bowtie -S -f random genome-reads.fa > genome-reads.fa.sam

transcript-reads.fa.sam: transcripts.1.ebwt transcript-reads.fa
	bowtie -S -f transcripts transcript-reads.fa > transcript-reads.fa.sam

transcript-reads.fa.map: transcripts.1.ebwt transcript-reads.fa
	bowtie -f -a --best --strata transcripts transcript-reads.fa > transcript-reads.fa.map

genome-reads.fa.bam: random.fa.fai genome-reads.fa.sam
	samtools view -bt random.fa.fai genome-reads.fa.sam > genome-reads.fa.bam

genome-reads.fa.sorted.bam: genome-reads.fa.bam
	samtools sort genome-reads.fa.bam genome-reads.fa.sorted
	samtools index genome-reads.fa.sorted.bam

genome-reads.fa.counts.pickle: genome-reads.fa.map random.fa
	python mapping-cov-3.py random.fa genome-reads.fa.map genome-reads.fa.counts.pickle

genome-reads.fa.keep.map: random.1.ebwt genome-reads.fa.keep
	bowtie -q -a --best --strata random genome-reads.fa.keep > genome-reads.fa.keep.map

genome-reads.fa.keep.abundfilt.keep.map: random.1.ebwt genome-reads.fa.keep.abundfilt.keep
	bowtie -q -a --best --strata random genome-reads.fa.keep.abundfilt.keep > genome-reads.fa.keep.abundfilt.keep.map

genome-reads.fa.map.cov: genome-reads.fa.map random.fa
	python mapping-genome-cov-3.py random.fa genome-reads.fa.map genome-reads.fa.map.cov

genome-reads.fa.keep.map.cov: genome-reads.fa.keep.map random.fa
	python mapping-genome-cov-3.py random.fa genome-reads.fa.keep.map genome-reads.fa.keep.map.cov

ecoliMG1655.1.ebwt: ecoliMG1655.fa
	bowtie-build ecoliMG1655.fa ecoliMG1655

ecoli_ref-5m.fastq.kh: ecoli_ref-5m.fastq
	${KHMER}/scripts/load-into-counting.py -k 20 -N 4 -x 5e8 ecoli_ref-5m.fastq.kh ecoli_ref-5m.fastq

ecoli_ref-5m.fastq.map: ecoli_ref-5m.fastq ecoliMG1655.1.ebwt
	bowtie -q -a --best --strata ecoliMG1655 ecoli_ref-5m.fastq > ecoli_ref-5m.fastq.map

ecoli_ref-5m.fastq.map.cov: ecoli_ref-5m.fastq.map ecoliMG1655.fa
	python mapping-genome-cov-3.py ecoliMG1655.fa ecoli_ref-5m.fastq.map ecoli_ref-5m.fastq.map.cov

ecoli_ref-5m.fastq.sam: ecoli_ref-5m.fastq ecoliMG1655.1.ebwt
	bowtie -S -q -a --best --strata ecoliMG1655 ecoli_ref-5m.fastq > ecoli_ref-5m.fastq.sam

ecoli_ref-5m.fastq.bam: ecoli_ref-5m.fastq.sam random.fa.fai
	samtools view -bt random.fa.fai ecoli_ref-5m.fastq.sam > ecoli_ref-5m.fastq.bam

ecoli_ref-5m.fastq.sorted.bam: ecoli_ref-5m.fastq.bam
	samtools sort ecoli_ref-5m.fastq.bam ecoli_ref-5m.fastq.sorted
	samtools index ecoli_ref-5m.fastq.sorted.bam

###


ecoli_ref.fastq.bz2.keep.map: ecoli_ref.fastq.bz2.keep ecoliMG1655.1.ebwt
	bowtie -q -a --best --strata ecoliMG1655 ecoli_ref.fastq.bz2.keep > ecoli_ref.fastq.bz2.keep.map

ecoli_ref.fastq.bz2.keep.map.cov: ecoli_ref.fastq.bz2.keep.map ecoliMG1655.1.ebwt
	python mapping-genome-cov-3.py ecoliMG1655.fa ecoli_ref.fastq.bz2.keep.map ecoli_ref.fastq.bz2.keep.map.cov

genome-reads.fa.keep.sam: genome-reads.fa.keep
	bowtie -S -f random genome-reads.fa.keep > genome-reads.fa.keep.sam

genome-reads.fa.keep.bam: genome-reads.fa.keep.sam
	samtools view -bt random.fa.fai genome-reads.fa.keep.sam > genome-reads.fa.keep.bam

genome-reads.fa.keep.sorted.bam: genome-reads.fa.keep.bam
	samtools sort genome-reads.fa.keep.bam genome-reads.fa.keep.sorted
	samtools index genome-reads.fa.keep.sorted.bam


genome-reads.fa.counts.kmer: genome-reads.fa.kh genome-reads.fa
	python ${KHMER}/scripts/count-median.py genome-reads.fa.kh genome-reads.fa genome-reads.fa.counts.kmer

genome-reads.fa.counts.cmp: genome-reads.fa.counts.pickle  genome-reads.fa.counts.kmer
	python compare-map-med.py genome-reads.fa.counts.pickle genome-reads.fa.counts.kmer > genome-reads.fa.counts.cmp

transcript-reads.fa.bam: transcript-reads.fa.sam transcripts.fa.fai
	samtools view -bt transcripts.fa.fai transcript-reads.fa.sam > transcript-reads.fa.bam

transcript-reads.fa.sorted.bam: transcript-reads.fa.bam
	samtools sort transcript-reads.fa.bam transcript-reads.fa.sorted
	samtools index transcript-reads.fa.sorted.bam

transcript-reads.fa.counts.pickle: transcript-reads.fa.map transcripts.fa
	python mapping-cov-3.py transcripts.fa transcript-reads.fa.map transcript-reads.fa.counts.pickle

transcript-reads.fa.counts.kmer: transcript-reads.fa.kh transcript-reads.fa
	python ${KHMER}/scripts/count-median.py transcript-reads.fa.kh transcript-reads.fa transcript-reads.fa.counts.kmer

transcript-reads.fa.counts.cmp: transcript-reads.fa.counts.pickle  transcript-reads.fa.counts.kmer
	python compare-map-med.py transcript-reads.fa.counts.pickle transcript-reads.fa.counts.kmer > transcript-reads.fa.counts.cmp

ecoli_ref-5m.fastq.counts.pickle: ecoli_ref-5m.fastq.map ecoliMG1655.fa
	python mapping-cov-3.py ecoliMG1655.fa ecoli_ref-5m.fastq.map ecoli_ref-5m.fastq.counts.pickle

ecoli_ref-5m.fastq.counts.kmer: ecoli_ref-5m.fastq.kh ecoli_ref-5m.fastq
	python ${KHMER}/scripts/count-median.py ecoli_ref-5m.fastq.kh ecoli_ref-5m.fastq ecoli_ref-5m.fastq.counts.kmer

ecoli_ref-5m.fastq.counts.cmp: ecoli_ref-5m.fastq.counts.pickle ecoli_ref-5m.fastq.counts.kmer
	python compare-map-med.py ecoli_ref-5m.fastq.counts.pickle ecoli_ref-5m.fastq.counts.kmer > ecoli_ref-5m.fastq.counts.cmp

#####

trinity-300.1.ebwt: trinity-300.fa
	bowtie-build trinity-300.fa trinity-300

mouse-5m.fq.map: mouse-5m.fq trinity-300.1.ebwt
	bowtie -q -a --best --strata trinity-300 mouse-5m.fq > mouse-5m.fq.map

mouse-5m.fq.kh: mouse-5m.fq
	${KHMER}/scripts/load-into-counting.py -k 20 -N 4 -x 1e9 mouse-5m.fq.kh mouse-5m.fq

mouse-5m.fq.counts.kmer: mouse-5m.fq.kh mouse-5m.fq
	${KHMER}/scripts/count-median.py mouse-5m.fq.kh mouse-5m.fq mouse-5m.fq.counts.kmer

mouse-5m.fq.counts.pickle: mouse-5m.fq.map trinity-300.fa
	python mapping-cov-3.py trinity-300.fa mouse-5m.fq.map mouse-5m.fq.counts.pickle

mouse-5m.fq.counts.cmp: mouse-5m.fq.counts.pickle mouse-5m.fq.counts.kmer
	python compare-map-med.py mouse-5m.fq.counts.pickle mouse-5m.fq.counts.kmer > mouse-5m.fq.counts.cmp

###

transcript-reads.fa.map.cov: transcript-reads.fa.map transcripts.fa
	python mapping-genome-cov-3.py transcripts.fa transcript-reads.fa.map transcript-reads.fa.map.cov

mouse-5m.fq.map.cov: mouse-5m.fq.map trinity-300.fa
	python mapping-genome-cov-3.py trinity-300.fa mouse-5m.fq.map mouse-5m.fq.map.cov


mouse-5m.fq.keep: mouse-5m.fq
	python $(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1e9 mouse-5m.fq

mouse-5m.fq.keep.map: mouse-5m.fq.keep
	bowtie -q -a --best --strata trinity-300 mouse-5m.fq.keep > mouse-5m.fq.keep.map

mouse-5m.fq.keep.map.cov: mouse-5m.fq.keep.map trinity-300.fa
	python mapping-genome-cov-3.py trinity-300.fa mouse-5m.fq.keep.map mouse-5m.fq.keep.map.cov

transcript-reads.fa.keep.map: transcript-reads.fa.keep
	bowtie -f -a --best --strata transcripts transcript-reads.fa.keep > transcript-reads.fa.keep.map

transcript-reads.fa.keep.map.cov: transcript-reads.fa.keep.map transcripts.fa
	python mapping-genome-cov-3.py transcripts.fa transcript-reads.fa.keep.map transcript-reads.fa.keep.map.cov

bacteria_mda_lane1.fastq.bz2.keep: bacteria_mda_lane1.fastq.bz2
	$(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1.6e9 -C 20 bacteria_mda_lane1.fastq.bz2 --savehash bacteria_mda_lane1.fastq.bz2.normC20k20.kh

bacteria_mda_lane1.fastq.bz2.keep.abundfilt: bacteria_mda_lane1.fastq.bz2.keep
	$(KHMER)/scripts/filter-abund.py bacteria_mda_lane1.fastq.bz2.normC20k20.kh bacteria_mda_lane1.fastq.bz2.keep

bacteria_mda_lane1.fastq.bz2.keep.abundfilt.keep: bacteria_mda_lane1.fastq.bz2.keep.abundfilt
	$(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1.6e9 -C 5 bacteria_mda_lane1.fastq.bz2.keep.abundfilt

sar.keep.assembly.fa: bacteria_mda_lane1.fastq.bz2.keep.abundfilt.keep
	velveth sar.27 27 -short -fastq bacteria_mda_lane1.fastq.bz2.keep.abundfilt.keep
	velvetg sar.27 -scaffolding no -exp_cov auto -cov_cutoff auto
	python $(KHMER)/sandbox/extract-long-sequences.py 1000 sar.27/contigs.fa > sar.keep.assembly.fa
	#	cp sar.27/contigs.fa sar.keep.assembly.fa

sar_assembly.report: sar324_contigs_lane1.fa sar.keep.assembly.fa
	dnadiff sar324_contigs_lane1.fa sar.keep.assembly.fa -p sar_assembly

bacteria_mda_lane7.fastq.bz2.keep: bacteria_mda_lane7.fastq.bz2
	$(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1.6e9 -C 20 bacteria_mda_lane7.fastq.bz2 --savehash bacteria_mda_lane7.fastq.bz2.normC20k20.kh

bacteria_mda_lane7.fastq.bz2.keep.abundfilt: bacteria_mda_lane7.fastq.bz2.keep
	$(KHMER)/scripts/filter-abund.py bacteria_mda_lane7.fastq.bz2.normC20k20.kh bacteria_mda_lane7.fastq.bz2.keep

bacteria_mda_lane7.fastq.bz2.keep.abundfilt.keep: bacteria_mda_lane7.fastq.bz2.keep.abundfilt
	$(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1.6e9 -C 5 bacteria_mda_lane7.fastq.bz2.keep.abundfilt

staph.keep.assembly.fa: bacteria_mda_lane7.fastq.bz2.keep.abundfilt.keep
	velveth staph.27 27 -short -fastq bacteria_mda_lane7.fastq.bz2.keep.abundfilt.keep
	velvetg staph.27 -scaffolding no -exp_cov auto -cov_cutoff auto
	python $(KHMER)/sandbox/extract-long-sequences.py 1000 staph.27/contigs.fa > staph.keep.assembly.fa
	#	cp staph.27/contigs.fa staph.keep.assembly.fa

orig_vs_staph_assembly.report: staph-genome.fa staph.keep.assembly.fa
	dnadiff staph-genome.fa staph.keep.assembly.fa -p orig_vs_staph_assembly

ecoli_ref.fastq.bz2.keep ecoli_ref.report: ecoli_ref.fastq.bz2
	$(KHMER)/scripts/normalize-by-median.py -R ecoli_ref.report -k 20 -N 4 -x 1.6e9 -C 20 ecoli_ref.fastq.bz2 --savehash ecoli_ref.fastq.bz2.normC20k20.kh

ecoli_ref.fastq.bz2.keep.abundfilt: ecoli_ref.fastq.bz2.keep
	$(KHMER)/scripts/filter-abund.py ecoli_ref.fastq.bz2.normC20k20.kh ecoli_ref.fastq.bz2.keep

ecoli_ref.fastq.bz2.keep.abundfilt.keep: ecoli_ref.fastq.bz2.keep.abundfilt
	$(KHMER)/scripts/normalize-by-median.py -k 20 -N 4 -x 1.6e9 -C 5 ecoli_ref.fastq.bz2.keep.abundfilt --savehash ecoli_ref.fastq.bz2.normC5k20.kh

ecoli_ref.fastq.bz2.keep.assembly.fa: ecoli_ref.fastq.bz2.keep.abundfilt.keep
	velveth ecoli.37 37 -short -fastq ecoli_ref.fastq.bz2.keep.abundfilt.keep
	velvetg ecoli.37 -scaffolding no -exp_cov auto -cov_cutoff auto
	python $(KHMER)/sandbox/extract-long-sequences.py 1000 ecoli.37/contigs.fa > ecoli_ref.fastq.bz2.keep.assembly.fa
	# 	cp ecoli.37/contigs.fa ecoli_ref.fastq.bz2.keep.assembly.fa

orig_vs_ecoli_assembly.report: ecoliMG1655.fa ecoli_ref.fastq.bz2.keep.assembly.fa
	dnadiff ecoliMG1655.fa ecoli_ref.fastq.bz2.keep.assembly.fa -p orig_vs_ecoli_assembly

ecoli_dn.faa: ecoli_ref.fastq.bz2.keep.assembly.fa
	/mnt/prokka-1.7/bin/prokka ecoli_ref.fastq.bz2.keep.assembly.fa --outdir ecoli_dn --prefix ecoli_dn --force
	cp ecoli_dn/ecoli_dn.faa .

sar_dn.faa: sar.keep.assembly.fa
	/mnt/prokka-1.7/bin/prokka sar.keep.assembly.fa --outdir sar_dn --prefix sar_dn --force
	cp sar_dn/sar_dn.faa .

staph_dn.faa: staph.keep.assembly.fa
	/mnt/prokka-1.7/bin/prokka staph.keep.assembly.fa --outdir staph_dn --prefix staph_dn --force
	cp staph_dn/staph_dn.faa .

sar_orig.faa: sar324_contigs_lane1.fa
	/mnt/prokka-1.7/bin/prokka sar324_contigs_lane1.fa --outdir sar_orig --prefix sar_orig --force
	cp sar_orig/sar_orig.faa .

sar_orig.x.sar_dn: sar_orig.faa sar_dn.faa
	formatdb -i sar_dn.faa -o T -p T
	blastall -i sar_orig.faa -d sar_dn.faa -p blastp -e 1e-3 -b 2 -v 2 -a 4 -o sar_orig.x.sar_dn

sar_dn.x.sar_orig: sar_dn.faa sar_orig.faa
	formatdb -i sar_orig.faa -o T -p T
	blastall -i sar_dn.faa -d sar_orig.faa -p blastp -e 1e-3 -b 2 -v 2 -a 4 -o sar_dn.x.sar_orig


####

sar324.1.ebwt: sar324_contigs_lane1.fa 
	bowtie-build sar324_contigs_lane1.fa sar324

staph.1.ebwt: staph-genome.fa
	bowtie-build staph-genome.fa staph

staph.rawreads.map.gz: staph.1.ebwt bacteria_mda_lane7.fastq.bz2
	bunzip2 -c bacteria_mda_lane7.fastq.bz2 | bowtie -p 8 -q -a --best --strata staph - | gzip -9c > staph.rawreads.map.gz

ecoli.rawreads.map.gz: ecoliMG1655.1.ebwt  ecoli_ref.fastq.bz2
	bunzip2 -c ecoli_ref.fastq.bz2 | bowtie -p 8 -q -a --best --strata ecoliMG1655 - | gzip -9c > ecoli.rawreads.map.gz

sar324.rawreads.map.gz: sar324.1.ebwt bacteria_mda_lane1.fastq.bz2
	bunzip2 -c bacteria_mda_lane1.fastq.bz2 | bowtie -p 8 -q -a --best --strata sar324 - | gzip -9c > sar324.rawreads.map.gz

staph.keep.rawreads.map.gz: staph.1.ebwt bacteria_mda_lane7.fastq.bz2.keep
	cat bacteria_mda_lane7.fastq.bz2.keep | bowtie -p 8 -q -a --best --strata staph - | gzip -9c > staph.keep.rawreads.map.gz

ecoli.keep.rawreads.map.gz: ecoliMG1655.1.ebwt  ecoli_ref.fastq.bz2.keep
	cat ecoli_ref.fastq.bz2.keep | bowtie -p 8 -q -a --best --strata ecoliMG1655 - | gzip -9c > ecoli.keep.rawreads.map.gz

sar324.keep.rawreads.map.gz: sar324.1.ebwt bacteria_mda_lane1.fastq.bz2.keep
	cat bacteria_mda_lane1.fastq.bz2.keep | bowtie -p 8 -q -a --best --strata sar324 - | gzip -9c > sar324.keep.rawreads.map.gz

ecoli.keep.rawreads.map.gz.cov: ecoli.keep.rawreads.map.gz ecoliMG1655.fa
	python mapping-genome-cov-3.py ecoliMG1655.fa ecoli.keep.rawreads.map.gz ecoli.keep.rawreads.map.gz.cov

sar324.keep.rawreads.map.gz.cov: sar324.keep.rawreads.map.gz sar324_contigs_lane1.fa
	python mapping-genome-cov-3.py sar324_contigs_lane1.fa sar324.keep.rawreads.map.gz sar324.keep.rawreads.map.gz.cov

staph.keep.rawreads.map.gz.cov: staph.keep.rawreads.map.gz staph-genome.fa
	python mapping-genome-cov-3.py staph-genome.fa staph.keep.rawreads.map.gz staph.keep.rawreads.map.gz.cov

ecoli.rawreads.map.gz.cov: ecoli.rawreads.map.gz ecoliMG1655.fa
	python mapping-genome-cov-3.py ecoliMG1655.fa ecoli.rawreads.map.gz ecoli.rawreads.map.gz.cov

sar324.rawreads.map.gz.cov: sar324.rawreads.map.gz sar324_contigs_lane1.fa
	python mapping-genome-cov-3.py sar324_contigs_lane1.fa sar324.rawreads.map.gz sar324.rawreads.map.gz.cov

staph.rawreads.map.gz.cov: staph.rawreads.map.gz staph-genome.fa
	python mapping-genome-cov-3.py staph-genome.fa staph.rawreads.map.gz staph.rawreads.map.gz.cov

../pipeline-data-new.tar.gz: 
	wget https://s3.amazonaws.com/public.ged.msu.edu/2012-paper-diginorm/pipeline-data-new.tar.gz -O ../pipeline-data-new.tar.gz
	tar -xzv --directory .. -f ../pipeline-data-new.tar.gz 

mapping.txt bacteria_mda_lane1.fastq.bz2 ecoliMG1655.fa trinity-300.fa sar324_contigs_lane1.fa staph-genome.fa mouse-5m.fq bacteria_mda_lane7.fastq.bz2 ecoli_ref-5m.fastq ecoli_ref.fastq.bz2:	../pipeline-data-new.tar.gz

update-gitignore:
	git status -s | grep \?\?\ [a-ZA-Z].* | awk '{ print $2 }'>> .gitignore

