ext<-'C:/Users/radar/Desktop/Boone/Ebird/'
################################################
##Variables
ababase<-read.csv('C:/Users/radar/Desktop/Boone/Ebird/ababase.csv',header=T)
radar<-'AKQ'
countylist<-list(VA=c('US-VA-036,US-VA-057,US-VA-073,US-VA-093,US-VA-095,US-VA-097,US-VA-101,US-VA-103,US-VA-115,US-VA-127,US-VA-133,US-VA-159,US-VA-181,US-VA-199,US-VA-007,US-VA-037,US-VA-041,US-VA-081,US-VA-083,US-VA-085,US-VA-087,US-VA-111,US-VA-135,US-VA-145,US-VA-147,US-VA-149,US-VA-175,US-VA-550,US-VA-710,US-VA-183,US-VA-800'),
                   NC=c('US-NC-015,US-NC-029,US-NC-041,US-NC-053,US-NC-073,US-NC-083,US-NC-131,US-NC-139,US-NC-143')
                 )
statelist<-names(countylist)
baseurl<-'http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=counties&counties='
worklist<-c(2008:2014,'2008-2014')
###############################################
# start code
#########start download#########################
setwd(paste0(ext,radar,'/'))
cl<-unlist(lapply(countylist,function(x){ceiling(nchar(x)/150)}))


for(i in worklist){
  #i<-worklist[13]
  final<-0
  nsamplelist<-list()
  for(s in 1:length(statelist)){
    #s<-2
    
    for(l in 1:cl[s]){
      #l<-1
      sub<-substr(countylist[[s]],(l-1)*150+1,l*150)
      download.file(paste0(baseurl,sub,'&bYear=',substr(i,1,4),'&eYear=',substr(i,(nchar(i)-3),nchar(i)),'&bMonth=1&eMonth=12&reportType=location&parentState=US-',statelist[s]),paste0('Ebird_',statelist[s],'_',i,'.',l))
      sub1<-read.delim(paste0('Ebird_',statelist[s],'_',i,'.',l),skip=14,header=F,row.names=1)[,1:48]
      nsamplelist[[paste0(statelist[s],l)]]<-t(read.delim(paste0('Ebird_',statelist[s],'_',i,'.',l),skip=13,nrow=1,header=F,row.names=1)[,1:48])
      test<-merge(t(t(sub1)*nsamplelist[[paste0(statelist[s],l)]][,1]),ababase,all.y=T,by.y='species',by.x=0)
      test[is.na(test)]<-0
      test<-test[,1:49]
      final<-final+test[,2:49]
      
    }
  }
  
  row.names(final)<-test$Row.names
  
  ebird<-as.data.frame(t(t(final)/apply(data.frame(nsamplelist),1,sum)))
  ebird[is.na(ebird)]<-0
  ebird<-ebird[apply(ebird,1,sum,na.rm=T)>0,]
  colnames(ebird)<-paste0(rep(1:12,1,each=4),'.',1:4)
  ##merege with aba code list
  ebird$id<-1:nrow(ebird)
  frame3<-merge(ebird,ababase,by.x='row.names',by.y='species')
  frame3<-frame3[order(frame3$id),]
  
  colnames(frame3)[1]<-'species'
  frame3<-frame3[,c('id','species','scientific','group','groupcode','raritycode','pelagic','shorebird','passerine','waterfowl',paste0(rep(1:12,1,each=4),'.',1:4))]
  
  mincol<-min(grep('^1.1',colnames(frame3)))
  maxcol<-max(grep('^12.4',colnames(frame3)))
  ##############################################
  #############ID common birds#########
  
  frame3$perennial<-0
  
  frame3$perennial[apply(frame3[,mincol:maxcol]>0.01,1,sum)>=46]<-1
  perennial<-frame3[frame3$perennial==1,]
  
  ###############################################
  ############ID rarities
  
  frame3$vagrant<-0
  frame3$vagrant[apply(frame3[,mincol:maxcol]<0.01,1,sum)>=44]<-1
  vagrant<-frame3[frame3$vagrant==1,]
  ##############################################
  #########uncommon fall 
  
  frame3$unfall<-0
  frame3$unfall[apply(frame3[,grep('^8.3',colnames(frame3)):grep('^11.2',colnames(frame3))]<0.01,1,sum)>=9]<-1
  unfall<-frame3[frame3$unfall==1,]
  ###############################################
  ##########common migrants?
  
  frame3$migrant<-0
  frame3$migrant[frame3$perennial==0&frame3$vagrant==0]<-1
  migrant<-frame3[frame3$migrant==1,]
  
  ################################################
  ##########breeder?
  
  #test<-frame3[apply((frame3[,mincol:maxcol]/apply(frame3[,mincol:maxcol],1,sum))[,grep('^6.1',colnames(frame3)):grep('^7.2',colnames(frame3))],1,sum)>.275,]
  frame3$breeder<-0
  #frame3$breeder[apply((frame3[,mincol:maxcol]/apply(frame3[,mincol:maxcol],1,sum))[,20:32],1,sum)>.275 & frame3$vagrant==0]<-1
  frame3$breeder[apply(frame3[,grep('^6.1',colnames(frame3)):grep('^7.2',colnames(frame3))]>.01,1,sum)>=3 & frame3$vagrant==0]<-1
  breeder<-frame3[frame3$breeder==1,]
  breeder<-breeder[order(breeder$groupcode),]
  ################################################
  ##########winter?
  
  frame3$winter<-0
  frame3$winter[apply((frame3[,mincol:maxcol]/apply(frame3[,mincol:maxcol],1,sum))[,c(45:48,1:8)],1,sum)>.275 & frame3$vagrant==0]<-1
  frame3$winter[apply(frame3[,c(grep('^11.3',colnames(frame3)):grep('^12.4',colnames(frame3)),grep('^1.1',colnames(frame3)):grep('^2.2',colnames(frame3)))]>.01,1,sum)>8]<-1
  winter<-frame3[frame3$winter==1 & frame3$perennial==0,]
  winter<-winter[order(winter$groupcode),]
  ################################################
  ##########transient migrant
  
  frame3$tranmigrant<-0
  frame3$tranmigrant[frame3$breeder==0&frame3$winter==0& frame3$migrant==1 &frame3$vagrant==0]<-1
  tranmigrant<-frame3[frame3$tranmigrant==1,]
  tranmigrant<-tranmigrant[order(tranmigrant$groupcode),]
  ################################################
  #########resident migrants 
  
  frame3$resmigrant<-0
  frame3$resmigrant[apply((frame3[,mincol:maxcol]/apply(frame3[,mincol:maxcol],1,sum))[,c(45:48,1:8)],1,sum)>.275 &frame3$perennial==1]<-1
  resmigrant<-frame3[frame3$resmigrant==1,]
  
  #test<-frame3[apply((frame3[,mincol:maxcol]/apply(frame3[,mincol:maxcol],1,sum))[,c(45:48,1:8)],1,sum)>.275 &frame3$perennial==1,]
  ##########final frame
  frame4<-frame3[,c(1:mincol-1,(maxcol+1):ncol(frame3),mincol:maxcol)]
  
  fall<-frame4[,c(1:grep('^1.1',colnames(frame4))-1,grep('^8.1',colnames(frame4)):grep('^11.4',colnames(frame4)))]
  #write.csv(frame4,paste0('Ebird_',radar,'_',i,'.csv'),row.names=F)
  write.csv(frame4,paste0('Ebird_',radar,'_',i,'.csv'),row.names=F)
  #############################################
  
}


#########################################################################################
#now to aggregate
################################################
################################################
#setwd('C:/Users/radar/Desktop/Boone/Ebird/AKQ/')
base<-read.csv(paste0('Ebird_',radar,'_2008-2014.csv'))
mincol<-min(grep('^X',colnames(base)))
maxcol<-max(grep('^X',colnames(base)))
#base1<-base[,mincol:maxcol]/apply(base[,mincol:maxcol],1,sum)
base1<-base[,mincol:maxcol]
base[,mincol:maxcol]<-base1
banswers<-aggregate(base[,mincol:maxcol],by=list(group=base$group,pelagic=base$pelagic,shorebird=base$shorebird,passerine=base$passerine,perennial=base$perennial,vagrant=base$vagrant,tranmigrant=base$tranmigrant,breeder=base$breeder,winter=base$winter,resmigrant=base$resmigrant,waterfowl=base$waterfowl,unfall=base$unfall),mean,na.rm=T)
banswers$year<-'all'
banswers<-banswers[apply(banswers[,5:mincol-1],1,sum)>0,]
finalframe<-banswers
##########################
for(i in c(2008:2014)){
  #i<-2008
  year<-read.csv(paste0('Ebird_',radar,'_',i,'.csv'))
  year1<-year[,mincol:maxcol]/apply(year[,mincol:maxcol],1,sum)
  year[,mincol:maxcol]<-year1
  frame1<-cbind(base[base$species%in%year$species,1:mincol-1],year[,mincol:maxcol])
  answers<-aggregate(frame1[,mincol:maxcol],by=list(group=frame1$group,pelagic=frame1$pelagic,shorebird=frame1$shorebird,passerine=frame1$passerine,perennial=frame1$perennial,vagrant=frame1$vagrant,tranmigrant=frame1$tranmigrant,breeder=frame1$breeder,winter=frame1$winter,resmigrant=frame1$resmigrant,waterfowl=frame1$waterfowl,unfall=frame1$unfall),mean,na.rm=T)
  answers$year<-i
  answers<-answers[apply(answers[,c('tranmigrant','breeder','winter')],1,sum)>0,]
  
  #assign(paste0('a',i),answers)
  
  finalframe<-rbind(finalframe,answers)
}

write.csv(finalframe,paste0(radar,'_grandfile.csv'),row.names=F)
