Meteor.methods({
  dataBatch: () => {
    cl('methods/dataBatch');
    try {
      // 1. 의사ID 획득(하드코딩)
      // 2. 의사별 환자리스트 획득(환자정보저장)
      // 3. 환자별 경과기록지 획득 / 저장
      // 4. 나의스케쥴 리스트 획득 / 저장

    } catch (e) {
      throw new Meteor.Error(e.message)
    }
    return 'data batch complete'
  }
});