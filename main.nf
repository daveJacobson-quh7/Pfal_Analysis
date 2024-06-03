nextflow.enable.dsl=2

/*
 * Input parameters: read pairs
 * Params are stored in the params.config file
 */


//Import modules for geo classifier

include { trimReads; humanMap; noHumanReads; map3D7; mapToRefs_bwa; mapToRefs_bowtie2; fastqc_afterTrim; fastqc_beforeTrim; getDepth } from './modules/mapping.nf'

include { trimmomaticTrim; humanMap_bwa; processBAM; makeGVCFs; extractMappedBAM; genomicsDBI } from './modules/gatk4_VCF.nf'

workflow mapHuman_then3D7 {
  myReads = Channel.fromFilePairs("${params.fastqDir}/*_{R1,R2}_001.fastq.gz")
  
  // fastqc_beforeTrim(myReads)
  trimReads(myReads)
  // fastqc_afterTrim(trimReads.out.trimmedFASTQ)

  humanMap(trimReads.out.trimmedFASTQ)

  noHumanReads(humanMap.out.sortedNoHumanBAM)

  map3D7(noHumanReads.out.humanRemoveFASTQ)

  getDepth(map3D7.out.mapped3D7)

}


workflow map3D7_thenHuman {
  myReads = Channel.fromFilePairs("${params.fastqDir}/*_{R1,R2}_001.fastq.gz")
  
  // fastqc_beforeTrim(myReads)
  trimReads(myReads)
  // fastqc_afterTrim(trimReads.out.trimmedFASTQ)

  humanMap(trimReads.out.trimmedFASTQ)

  noHumanReads(humanMap.out.sortedNoHumanBAM)

  map3D7(noHumanReads.out.humanRemoveFASTQ)

}

workflow mapFlanking {

   myReads = Channel.fromFilePairs("${params.fastqDir}/*_{R1,R2}_001.fastq.gz")
  
  // fastqc_beforeTrim(myReads)
  trimReads(myReads)
  // fastqc_afterTrim(trimReads.out.trimmedFASTQ)

  humanMap(trimReads.out.trimmedFASTQ)

  noHumanReads(humanMap.out.sortedNoHumanBAM)

  mapToRefs_bowtie2(noHumanReads.out.humanRemoveFASTQ)

  mapToRefs_bwa(noHumanReads.out.humanRemoveFASTQ)

}

workflow just3D7 {
  myReads = Channel.fromFilePairs("$baseDir/cleanReads/*_{R1,R2}.fastq.gz")

  map3D7(myReads)
}

workflow myDepth {
  // myReads = Channel.fromFilePairs("$baseDir/cleanReads/*_{R1,R2}.fastq.gz")
  bamFiles =  Channel.fromPath("$baseDir/bowtie2Mapping_summary/*bam")
  bamFiles.view()

  getDepth(bamFiles)
}

workflow optimizedGATK4_VCF {
  myReads = Channel.fromFilePairs("${params.fastqDir}/*_{R1,R2}_001.fastq.gz")
  // chromosomes = Channel.fromList(['Nu_CHR01','Nu_CHR02','Nu_CHR03','Nu_CHR04','Nu_CHR05','Nu_CHR06','Nu_CHR07','Nu_CHR08','Nu_CHR09','Nu_CHR10','Nu_CHR11','Nu_CHR12','Nu_CHR13','Nu_CHR14'])
  chromosomes = Channel.fromList(['1', '2','3','4','5','6','7','8','9','10','11','12','13','14'])

  trimmomaticTrim(myReads)
  humanMap_bwa(trimmomaticTrim.out.trimmedFASTQ)
  processBAM(humanMap_bwa.out.sortedNoHumanBAM)
  extractMappedBAM(processBAM.out.sortedDupBam)
  makeGVCFs(extractMappedBAM.out.sortedDupBamPf, chromosomes)

  // chr_frequency =  [ "1": 2, "2": 2, "3": 2, "4": 2,"5": 2, "6": 2,"7": 2, "8": 2,"9": 2, "10": 2,"11": 2, "12": 2,"13": 2, "14": 2]
  // makeGVCFs.out.perChromGVCF.view()
  // makeGVCFs.out.perChromGVCF_tuple.view()
  fullGVCFsByChrom = makeGVCFs.out.perChromGVCF_tuple.groupTuple(by:1)
  genomicsDBI(fullGVCFsByChrom)
  

  // fullGVCFs.map{ sample, chrom, vcf -> tuple( groupKey(chrom, chr_frequency[chrom]), vcf)}.groupTuple().view()
  // fullGVCFs.groupTuple(by: 1).view()
}