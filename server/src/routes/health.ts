import { Router } from 'express';
import { AppDataSource } from '../index';
import { Pet } from '../entities/Pet';
import { HealthRecord } from '../entities/HealthRecord';
import { authMiddleware, AuthRequest } from '../middleware/auth';

const router = Router();

// 获取宠物健康记录列表
router.get('/:id/health-records', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const { record_type, limit = 50 } = req.query;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const validTypes = ['vaccination', 'illness', 'medication', 'checkup'];
    if (record_type && !validTypes.includes(record_type as string)) {
      return res.status(400).json({ code: 400, message: 'Invalid record_type', data: null });
    }

    const recordRepo = AppDataSource.getRepository(HealthRecord);
    const where: any = { pet_id: parseInt(id) };
    if (record_type) {
      where.record_type = record_type;
    }

    const take = Math.min(Number(limit), 100);

    const records = await recordRepo.find({
      where,
      order: { record_date: 'DESC', created_at: 'DESC' },
      take
    });

    res.json({ code: 0, message: 'Success', data: records });
  } catch (error) {
    console.error('Failed to get health records:', error);
    res.status(500).json({ code: 500, message: 'Failed to get health records', data: null });
  }
});

// 获取单条健康记录
router.get('/:id/health-records/:recordId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id, recordId } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const recordRepo = AppDataSource.getRepository(HealthRecord);
    const record = await recordRepo.findOne({
      where: { id: parseInt(recordId), pet_id: parseInt(id) }
    });

    if (!record) {
      return res.status(404).json({ code: 404, message: 'Health record not found', data: null });
    }

    res.json({ code: 0, message: 'Success', data: record });
  } catch (error) {
    console.error('Failed to get health record:', error);
    res.status(500).json({ code: 500, message: 'Failed to get health record', data: null });
  }
});

// 创建健康记录
router.post('/:id/health-records', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const {
      record_type,
      title,
      description,
      record_date,
      end_date,
      vaccine_name,
      next_vaccination_date,
      symptoms,
      diagnosis,
      vet_name,
      hospital,
      medicine_name,
      dosage,
      frequency,
      duration_days,
      weight,
      temperature,
      heart_rate,
      checkup_result,
      cost,
      notes
    } = req.body;

    if (!record_type || !title) {
      return res.status(400).json({ code: 400, message: 'record_type and title are required', data: null });
    }

    if (title.length > 200) {
      return res.status(400).json({ code: 400, message: 'Title is too long (max 200 characters)', data: null });
    }

    const validTypes = ['vaccination', 'illness', 'medication', 'checkup'];
    if (!validTypes.includes(record_type)) {
      return res.status(400).json({ code: 400, message: 'Invalid record_type', data: null });
    }

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const recordRepo = AppDataSource.getRepository(HealthRecord);

    const recordData: any = {
      pet_id: parseInt(id),
      record_type,
      title,
      description: description || null
    };

    // 处理日期字段
    if (record_date) recordData.record_date = record_date;
    if (end_date) recordData.end_date = end_date;
    if (next_vaccination_date) recordData.next_vaccination_date = next_vaccination_date;

    // 字符串字段
    if (vaccine_name) recordData.vaccine_name = vaccine_name;
    if (symptoms) recordData.symptoms = symptoms;
    if (diagnosis) recordData.diagnosis = diagnosis;
    if (vet_name) recordData.vet_name = vet_name;
    if (hospital) recordData.hospital = hospital;
    if (medicine_name) recordData.medicine_name = medicine_name;
    if (dosage) recordData.dosage = dosage;
    if (frequency) recordData.frequency = frequency;
    if (duration_days) recordData.duration_days = parseInt(duration_days);
    if (checkup_result) recordData.checkup_result = checkup_result;
    if (notes) recordData.notes = notes;

    // 数字字段
    if (weight) recordData.weight = parseFloat(weight);
    if (temperature) recordData.temperature = parseFloat(temperature);
    if (heart_rate) recordData.heart_rate = parseInt(heart_rate);
    if (cost) recordData.cost = parseFloat(cost);

    const record = recordRepo.create(recordData);
    await recordRepo.save(record);

    res.json({ code: 0, message: 'Success', data: record });
  } catch (error) {
    console.error('Failed to create health record:', error);
    res.status(500).json({ code: 500, message: 'Failed to create health record', data: null });
  }
});

// 更新健康记录
router.put('/:id/health-records/:recordId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id, recordId } = req.params;
    const {
      title,
      description,
      record_date,
      end_date,
      vaccine_name,
      next_vaccination_date,
      symptoms,
      diagnosis,
      vet_name,
      hospital,
      medicine_name,
      dosage,
      frequency,
      duration_days,
      weight,
      temperature,
      heart_rate,
      checkup_result,
      cost,
      notes
    } = req.body;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const recordRepo = AppDataSource.getRepository(HealthRecord);
    const record = await recordRepo.findOne({
      where: { id: parseInt(recordId), pet_id: parseInt(id) }
    });

    if (!record) {
      return res.status(404).json({ code: 404, message: 'Health record not found', data: null });
    }

    // 更新字段
    if (title !== undefined) record.title = title;
    if (description !== undefined) record.description = description;
    if (record_date !== undefined) record.record_date = record_date;
    if (end_date !== undefined) record.end_date = end_date;
    if (vaccine_name !== undefined) record.vaccine_name = vaccine_name;
    if (next_vaccination_date !== undefined) record.next_vaccination_date = next_vaccination_date;
    if (symptoms !== undefined) record.symptoms = symptoms;
    if (diagnosis !== undefined) record.diagnosis = diagnosis;
    if (vet_name !== undefined) record.vet_name = vet_name;
    if (hospital !== undefined) record.hospital = hospital;
    if (medicine_name !== undefined) record.medicine_name = medicine_name;
    if (dosage !== undefined) record.dosage = dosage;
    if (frequency !== undefined) record.frequency = frequency;
    if (duration_days !== undefined) record.duration_days = duration_days;
    if (weight !== undefined) record.weight = weight;
    if (temperature !== undefined) record.temperature = temperature;
    if (heart_rate !== undefined) record.heart_rate = heart_rate;
    if (checkup_result !== undefined) record.checkup_result = checkup_result;
    if (cost !== undefined) record.cost = cost;
    if (notes !== undefined) record.notes = notes;

    await recordRepo.save(record);
    res.json({ code: 0, message: 'Success', data: record });
  } catch (error) {
    console.error('Failed to update health record:', error);
    res.status(500).json({ code: 500, message: 'Failed to update health record', data: null });
  }
});

// 删除健康记录
router.delete('/:id/health-records/:recordId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id, recordId } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const recordRepo = AppDataSource.getRepository(HealthRecord);
    const record = await recordRepo.findOne({
      where: { id: parseInt(recordId), pet_id: parseInt(id) }
    });

    if (!record) {
      return res.status(404).json({ code: 404, message: 'Health record not found', data: null });
    }

    await recordRepo.remove(record);
    res.json({ code: 0, message: 'Success', data: { deleted: true } });
  } catch (error) {
    console.error('Failed to delete health record:', error);
    res.status(500).json({ code: 500, message: 'Failed to delete health record', data: null });
  }
});

export default router;
